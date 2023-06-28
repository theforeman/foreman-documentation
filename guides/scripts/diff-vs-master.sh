#!/bin/bash
CURRENT_BRANCH=$(git branch --show-current)
BRANCH1=${1:-$CURRENT_BRANCH}
BRANCH2=${2:-master}

rm -rf build-*/ *.diff

set -e
for BRANCH in $BRANCH1 $BRANCH2; do
  git checkout $BRANCH
  for BUILD in foreman-el foreman-deb katello satellite; do
    make clean
    make -j$(nproc) BUILD=$BUILD BUILD_DIR=../build-$BUILD-$BRANCH html
  done
done
git checkout $BRANCH1
set +e

set -x
for BUILD in foreman-el foreman-deb katello satellite; do
  diff -r build-$BUILD-$BRANCH1 build-$BUILD-$BRANCH2 > $BUILD-$BRANCH1-vs-$BRANCH2.diff
done
set +x

echo "Done! Make sure to delete build-*/ and *.diff. Cheers!"
