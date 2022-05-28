#!/usr/bin/env node
const fs = require('node:fs');
const { execSync } = require('node:child_process');
const readdirGlob = require('readdir-glob');
const core = require('@actions/core');
const plist = require('plist');

core.startGroup(`Generating LinuxMain for swift package`);
execSync(
  `swift test --generate-linuxmain`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
core.endGroup();

core.startGroup(`Generating XCode project for swift package`);
execSync(
  `swift package generate-xcodeproj \
    --xcconfig-overrides Helpers/DynamicCodableKit.xcconfig \
    --skip-extra-files`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
core.endGroup();

const package = JSON.parse(fs.readFileSync('package.json', 'utf8'));
core.startGroup(`Updating version to ${package.version} in plist`);
const plistGlobberer = readdirGlob('.', { pattern: 'DynamicCodableKit.xcodeproj/*.plist' });
plistGlobberer.on(
  'match',
  m => {
    const buffer = plist.parse(fs.readFileSync(m.absolute, 'utf8'));
    const props = JSON.parse(JSON.stringify(buffer));
    // props.CFBundleVersion = package.version;
    props.CFBundleShortVersionString = package.version;
    fs.writeFileSync(m.absolute, plist.build(props));
    core.endGroup();
  }
);

plistGlobberer.on('error', err => { core.error(err); });
