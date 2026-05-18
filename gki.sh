#!/bin/bash

set -e

BASE_URL="https://android.googlesource.com"
DEFAULT_REVISION="master-kernel-build-2021"
JOBS=4

echo "### Kernel Source Clone Script ###"
echo "Base URL : $BASE_URL"
echo "Default Revision : $DEFAULT_REVISION"
echo ""

clone_project() {
  local path="$1"
  local name="$2"
  local revision="${3:-$DEFAULT_REVISION}"
  local clone_depth="${4:-}"

  echo "Cloning $name -> $path (revision: $revision)"

  mkdir -p "$(dirname "$path")"

  local depth_flag=""
  [[ -n "$clone_depth" ]] && depth_flag="--depth=$clone_depth"

  if [[ -d "$path/.git" ]]; then
    echo "Already exists, fetching latest..."
    git -C "$path" fetch origin $depth_flag
  else
    git clone $depth_flag "$BASE_URL/$name" "$path"
  fi

  # Checkout specific revision jika bukan default
  if [[ "$revision" != "$DEFAULT_REVISION" ]]; then
    echo "Checkout revision: $revision"
    git -C "$path" checkout "$revision" 2>/dev/null || \
    git -C "$path" checkout -b local-"$revision" "origin/$revision" 2>/dev/null || \
    git -C "$path" checkout "$revision" -- 2>/dev/null || \
    echo "Failed checkout $revision, skip."
  fi

  echo ""
}

clone_project "build" \
  "kernel/build"

clone_project "hikey-modules" \
  "kernel/hikey-modules" \
  "6f0a2a72f849d8bb8e708587582c20019ef91a3c"

clone_project "common" \
  "kernel/common" \
  "android12-5.10"

clone_project "kernel/configs" \
  "kernel/configs"

clone_project "common-modules/virtual-device" \
  "kernel/common-modules/virtual-device" \
  "a89e3169b6f22716d9b9c80fd1e0034bfd3fd492"

clone_project "prebuilts-master/clang/host/linux-x86" \
  "platform/prebuilts/clang/host/linux-x86" \
  "$DEFAULT_REVISION" \
  "1"

clone_project "prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8" \
  "platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8" \
  "$DEFAULT_REVISION" \
  "1"

clone_project "prebuilts/build-tools" \
  "platform/prebuilts/build-tools" \
  "$DEFAULT_REVISION" \
  "1"

clone_project "prebuilts/kernel-build-tools" \
  "kernel/prebuilts/build-tools" \
  "$DEFAULT_REVISION" \
  "1"

clone_project "tools/mkbootimg" \
  "platform/system/tools/mkbootimg"

clone_project "kernel/tests" \
  "kernel/tests" \
  "main-kernel" \
  "1"

