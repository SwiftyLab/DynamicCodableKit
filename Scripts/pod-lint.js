#!/usr/bin/env node
const { execSync } = require('node:child_process');

execSync(
  'pod lib lint --no-clean --allow-warnings --verbose', {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);