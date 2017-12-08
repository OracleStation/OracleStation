#!/bin/bash

if [ "$BUILD_TESTING" = true ] && [ "$TRAVIS_PULL_REQUEST" = false ]; then
	echo "Building changelog..."
	python3 tools/pull_changelogs.py html/changelogs/.all_changelog.yml $GITHUB_ACCOUNT_NAME $GITHUB_ACCESS_TOKEN
	python3 tools/ss13_genchangelog.py html/changelog.html html/changelogs
fi
