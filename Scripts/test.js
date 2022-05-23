#!/usr/bin/env node
const process = require('node:process');
const { execSync } = require('node:child_process');

const args = process.argv.slice(2).join(' ');
execSync(
  `swift test ${args} --verbose --enable-code-coverage`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);