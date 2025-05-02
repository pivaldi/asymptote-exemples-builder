#!/usr/bin/env bash

. "$(dirname "$0")/shared.rc" || die $?

rsync -auv \
    --exclude='*.buildinfo' \
    --exclude='*.gif' \
    --exclude='*.mp4' \
    --exclude='*.pdf' \
    --exclude="*.$EXTIMAG" \
    --exclude='*.svg' \
    --include='*.md' \
    --include='*/' \
    --exclude='*' \
    --delete "$BUILD_MD_HEXO_PAGE_DIR" "${HOME}/code/pi/piprime-blog/hexo/source/asymptote/" || exit 1

rsync -auv \
    --exclude='*+*.pdf' \
    --exclude='*converted-to.pdf' \
    --exclude='*.buildinfo' \
    --exclude='*.md' \
    --include='*.gif' \
    --include='*.mp4' \
    --include='*.pdf' \
    --include="*.$EXTIMAG" \
    --include='*.svg' \
    --include='*/' \
    --exclude='*' \
    --delete "$BUILD_MD_HEXO_PAGE_DIR" "${HOME}/code/pi/piprime-blog/hexo/source/media/asymptote/" || exit 1

rsync -auv \
    --include='*.md' \
    --include='*/' \
    --exclude='*' \
    --delete "$BUILD_MD_HEXO_POST_DIR" "${HOME}/code/pi/piprime-blog/hexo/source/_posts/en/asymptote/" || exit 1
