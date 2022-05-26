#!/usr/bin/env node
const { execSync } = require('node:child_process');

execSync(
  `swift run mint install unsignedapps/swift-create-xcframework \
   && swift create-xcframework`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
