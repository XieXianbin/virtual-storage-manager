#!/bin/sh

# Copyright 2014 Intel Corporation, All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the"License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.

#-------------------------------------------------------------------------------
#            Usage
#-------------------------------------------------------------------------------

alias | grep  -q cp
if [ $? -eq 0 ]; then
  unalias cp
fi
alias | grep  -q mv
if [ $? -eq 0 ]; then
  unalias mv
fi
alias | grep  -q rm
if [ $? -eq 0 ]; then
  unalias rm
fi

function usage() {
    cat << EOF
Usage: $0

Pack vsm:
    The tool can help to pull all necessary documents, binaries into one place,
    and maintain an expected folder structure for following release package generation.

Options:
  --help | -h
    Print usage information.
  --version | -v
    The version of release vsm.
EOF
    exit 0
}

VERSION="1.1"
while [ $# -gt 0 ]; do
  case "$1" in
    -h) usage ;;
    --help) usage ;;
    -v| --version) VERSION=$2 ;;
    *) shift ;;
  esac
  shift
done

set -e
set -o xtrace

TOPDIR=$(cd $(dirname "$0") && pwd)
TEMP=`mktemp`; rm -rfv $TEMP >/dev/null; mkdir -p $TEMP;
DATE=`date "+%Y%m%d"`

mkdir -p release/$VERSION-$DATE

bash +x buildrpm

sudo cp -rf README.md release/$VERSION-$DATE/README
sudo cp -rf INSTALL.md release/$VERSION-$DATE
sudo cp -rf INSTALL.pdf release/$VERSION-$DATE
sudo cp -rf install.sh release/$VERSION-$DATE
sudo cp -rf uninstall.sh release/$VERSION-$DATE
sudo cp -rf LICENSE release/$VERSION-$DATE
sudo cp -rf NOTICE release/$VERSION-$DATE
sudo cp -rf CHANGELOG.md release/$VERSION-$DATE
sudo cp -rf CHANGELOG.pdf release/$VERSION-$DATE
sudo cp -rf hostrc release/$VERSION-$DATE
sudo cp -rf manifest release/$VERSION-$DATE
sudo cp -rf vsmrepo release/$VERSION-$DATE

cd release
tar -czvf $VERSION-$DATE.tar.gz $VERSION-$DATE
rm -rf $VERSION-$DATE
cd $TOPDIR

set +o xtrace
