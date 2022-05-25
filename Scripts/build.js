#!/usr/bin/env node
const process = require('node:process');
const { execSync } = require('node:child_process');

const args = process.argv.slice(2).join(' ')
execSync(
  `swift build ${args} --verbose \
    -Xswiftc \
    -emit-symbol-graph \
    -Xswiftc \
    -emit-symbol-graph-dir \
    -Xswiftc .build`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
