#!/usr/bin/env bash

set -e
set -x

npm test
npm run dist
git add .
git commit -m "Update dist files"
npm version patch -m "Release %s"
git push
git push --tags
npm publish

