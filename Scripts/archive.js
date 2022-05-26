#!/usr/bin/env node
const fs = require('node:fs');
const path = require('node:path');
const process = require('node:process');
const { execSync } = require('node:child_process');
const archiver = require('archiver');
const readdirGlob = require('readdir-glob');

try {
  execSync(
    `which carthage`, {
      encoding: 'utf-8'
    }
  );
} catch (error) {
  execSync(
    `brew install carthage`, {
      stdio: ['inherit', 'inherit', 'inherit'],
      encoding: 'utf-8'
    }
  );
}

execSync(
  `carthage build \
    --no-skip-current \
    --use-xcframeworks \
    --platform macOS,iOS,watchOS,tvOS`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);

const args = process.argv.slice(2).join(' ');
const xcframeworkGlobberer = readdirGlob('.', { pattern: 'Carthage/Build/*.xcframework' });
xcframeworkGlobberer.on(
  'match',
  m => {
    const xcframework = path.basename(m.relative);
    const name = path.basename(xcframework, path.extname(xcframework));
    const archiveName = [name, args].filter(x => typeof x === 'string' && x.length > 0).join('-');
    const output = fs.createWriteStream(`${archiveName}.xcframework.zip`);
    const archive = archiver('zip');
    archive.directory(m.absolute, xcframework);
    archive.file('package.json');
    archive.file('LICENSE');
    archive.file(`Helpers/${name}.podspec`, { name: `${name}.podspec` });
    archive.pipe(output);
    archive.finalize();
    const archivePath = path.normalize(path.join(process.cwd(), output.path));
    console.log(`Created archive '${archivePath}'`);
  }
);

xcframeworkGlobberer.on(
  'error',
  err => {
    console.error('fatal error', err);
  }
);
