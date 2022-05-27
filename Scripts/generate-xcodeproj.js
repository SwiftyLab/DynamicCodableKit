#!/usr/bin/env node
const { execSync } = require('node:child_process');

execSync(
  `swift package generate-xcodeproj \
    --xcconfig-overrides Helpers/DynamicCodableKit.xcconfig \
    --skip-extra-files`, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
