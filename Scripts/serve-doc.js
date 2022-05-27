#!/usr/bin/env node
const { execSync } = require('node:child_process');
const core = require('@actions/core');

const hostingDocGenCommandFormat = (basePath, outPath) =>
 `swift package --verbose \
   --allow-writing-to-directory .docc-build \
   generate-documentation \
   --disable-indexing \
   --transform-for-static-hosting \
   --hosting-base-path ${basePath} \
   --output-path ${outPath}`;

const hostingDocGenCommand = hostingDocGenCommandFormat(
  'DynamicCodableKit',
  '.docc-build'
);

core.startGroup(`Generating Documentation for Hosting Online`);
execSync(hostingDocGenCommand, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
core.endGroup();

const version = process.argv.slice(2).at(0);
if (!version) return;
const hostingVersionedDocGenCommand = hostingDocGenCommandFormat(
  version,
  `.docc-build/${version}`
);

core.startGroup(`Generating ${version} Specific Documentation for Hosting Online`);
execSync(hostingVersionedDocGenCommand, {
    stdio: ['inherit', 'inherit', 'inherit'],
    encoding: 'utf-8'
  }
);
core.endGroup();
