#!/bin/bash

# Copyright (c) 2018, Philippe Ivaldi <www.piprime.fr>

# This program is free software ; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation ; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY ; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program ; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

. $(dirname $0)/shared.rc || exit 1

for topic in $TOPICS; do
  [ -e ${TMP_PROJECT_DIR}${topic} ] || {
    mkdir -p "${TMP_PROJECT_DIR}${topic}" || exit 1
  }

  mkdir -p ${BUILD_DIR}{xml,html,md}/${topic}
  mkdir -p ${BUILD_DIR}/asset/{asy/${topic},script,style}
done

echo "Build directory tree is created in $BUILD_DIR"
type tree &> /dev/null && {
  tree -d "$BUILD_DIR"
}


# Local variables:
# coding: utf-8
# End:
