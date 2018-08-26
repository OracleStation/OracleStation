#!/bin/bash
set -e

if [ "$BUILD_TOOLS" = true ]; then
      pip install --user PyYaml -q
      pip install --user beautifulsoup4 -q
fi;
