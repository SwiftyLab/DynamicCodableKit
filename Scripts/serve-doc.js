#!/usr/bin/env node
const { execSync } = require('node:child_process');

execSync(
  'swift package --verbose \
    --allow-writing-to-directory .docc-build \
    generate-documentation \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path dynamic-codable-kit \
    --output-path .docc-build', {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);