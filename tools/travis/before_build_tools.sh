#!/bin/bash
set -e

if [ "$DM_MAPFILE" = "loadallmaps" ]; then
    python tools/travis/template_dm_generator.py
fi;
