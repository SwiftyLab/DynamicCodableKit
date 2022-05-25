#!/usr/bin/env node
const fs = require('node:fs');
const path = require('node:path');
const process = require('node:process');
const archiver = require('archiver');
const readdirGlob = require('readdir-glob');
const { execSync } = require('node:child_process');

execSync(
  'swift package --verbose generate-documentation \
    --fallback-display-name DynamicCodableKit \
    --fallback-bundle-identifier com.example.DynamicCodableKit \
    --fallback-bundle-version 1 \
    --additional-symbol-graph-dir .build', {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);

const args = process.argv.slice(2).join(' ');
const doccGlobberer = readdirGlob('.', { pattern: '.build/plugins/Swift-DocC/outputs/*.doccarchive' });
doccGlobberer.on(
  'match',
  m => {
    const docc = path.basename(m.relative);
    const name = path.basename(docc, path.extname(docc));
    const archiveName = [name, args].filter(x => typeof x === 'string' && x.length > 0).join('-');
    const output = fs.createWriteStream(`${archiveName}-doccarchive.zip`);
    const archive = archiver('zip');
    archive.directory(m.absolute, docc);
    archive.pipe(output);
    archive.finalize();
    const archivePath = path.normalize(path.join(process.cwd(), output.path));
    console.log(`Created archive '${archivePath}'`);
  }
);

doccGlobberer.on(
  'error',
  err => {
    console.error('fatal error', err);
  }
);
