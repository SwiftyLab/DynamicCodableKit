#!/usr/bin/env node
const fs = require('node:fs');
const path = require('node:path');
const process = require('node:process');
const { execSync } = require('node:child_process');
const archiver = require('archiver');
const readdirGlob = require('readdir-glob');
const core = require('@actions/core');

try {
  execSync(
    `which carthage`, {
      encoding: 'utf-8'
    }
  );
} catch (error) {
  core.startGroup(`Installing Carthage with Homebrew`);
  execSync(
    `brew install carthage`, {
      stdio: ['inherit', 'inherit', 'inherit'],
      encoding: 'utf-8'
    }
  );
  core.endGroup();
}

core.startGroup(`Building XCFramework with Carthage`);
execSync(
  `carthage build \
    --no-skip-current \
    --use-xcframeworks \
    --platform macOS,iOS,watchOS,tvOS`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
core.endGroup();

const args = process.argv.slice(2).join(' ');
const xcframeworkGlobberer = readdirGlob('.', { pattern: 'Carthage/Build/*.xcframework' });
xcframeworkGlobberer.on(
  'match',
  m => {
    core.startGroup(`Zipping XCFramework`);
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
    core.info(`Created archive '${archivePath}'`);
    core.endGroup();
  }
);

xcframeworkGlobberer.on('error', err => { core.error(err); });
