#!/usr/bin/env node
const { execSync } = require('node:child_process');

execSync(
  'swift package generate-documentation \
    --fallback-display-name DynamicCodableKit \
    --fallback-bundle-identifier com.example.DynamicCodableKit \
    --fallback-bundle-version 1 \
    --additional-symbol-graph-dir .build', {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);