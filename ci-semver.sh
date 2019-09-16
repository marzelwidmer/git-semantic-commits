#!/bin/sh
# Semantic Versioning 2.0.0 guideline
#
# Given a version number MAJOR.MINOR.PATCH, increment the:
# MAJOR version when you make incompatible API changes, (breaking|major|BREAKING CHANGE)
# MINOR version when you add functionality in a backwards-compatible manner, and (feature|minor|feat)
# PATCH version when you make backwards-compatible bug fixes. (fix|patch|docs|style|refactor|perf|test|chore)
GIT_REV_LIST=`git rev-list --tags --max-count=1`
GIT_REV_LAST=`git rev-parse HEAD`
VERSION='0.0.0'
if [[ -n $GIT_REV_LIST ]]; then
    VERSION=`git describe --tags $GIT_REV_LIST`
fi
# split into array
VERSION_BITS=(${VERSION//./ })
#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}

MAJOR_COUNT_OF_COMMIT_MSG=`git log $GIT_REV_LIST..$GIT_REV_LAST --pretty=%B | egrep -c '^(breaking:|major:|BREAKING CHANGE:)'`
MINOR_COUNT_OF_COMMIT_MSG=`git log $GIT_REV_LIST..$GIT_REV_LAST --pretty=%B | egrep -c '^(feature:|minor:|feat:)'`
PATCH_COUNT_OF_COMMIT_MSG=`git log $GIT_REV_LIST..$GIT_REV_LAST --pretty=%B | egrep -c '^(fix:|patch:|docs:|style:|refactor:|perf:|test:|chore:)'`
if [ $PATCH_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM3=$((VNUM3+1))
fi
if [ $MINOR_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM2=$((VNUM2+1))
    VNUM3=0
fi
if [ $MAJOR_COUNT_OF_COMMIT_MSG -gt 0 ]; then
    VNUM1=$((VNUM1+1))
    VNUM2=0
    VNUM3=0
fi
# count all commits for a branch
GIT_COMMIT_COUNT=`git rev-list --count HEAD`
#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo $NEW_TAG
