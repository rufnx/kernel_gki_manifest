#!/bin/bash

BASE_URL="https://android.googlesource.com"
DEFAULT_BRANCH="master-kernel-build-2021"

declare -A PROJECTS=(
  ["build"]="kernel/build|$DEFAULT_BRANCH|0|aosp"
  ["hikey-modules"]="kernel/hikey-modules|android12-5.10|0|aosp"
  ["common"]="https://github.com/rufnx/android_kernel_common_12-5.10|nethunter|0|custom"
  ["kernel/configs"]="kernel/configs|$DEFAULT_BRANCH|0|aosp"
  ["common-modules/virtual-device"]="kernel/common-modules/virtual-device|android12-5.10|0|aosp"
  ["prebuilts-master/clang/host/linux-x86"]="platform/prebuilts/clang/host/linux-x86|$DEFAULT_BRANCH|1|aosp"
  ["prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8"]="platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8|$DEFAULT_BRANCH|1|aosp"
  ["prebuilts/build-tools"]="platform/prebuilts/build-tools|$DEFAULT_BRANCH|1|aosp"
  ["prebuilts/kernel-build-tools"]="kernel/prebuilts/build-tools|$DEFAULT_BRANCH|1|aosp"
  ["tools/mkbootimg"]="platform/system/tools/mkbootimg|$DEFAULT_BRANCH|0|aosp"
)

clone_project() {
  local path="$1"
  local name="$2"
  local branch="$3"
  local shallow="$4"
  local remote_type="$5"

  local url
  if [[ "$remote_type" == "custom" ]]; then
    url="$name"
  else
    url="$BASE_URL/$name"
  fi

  local depth_flag=""
  [[ "$shallow" == "1" ]] && depth_flag="--depth=1"

  echo ">>> Cloning → $path ($branch)"
  if [[ -d "$path/.git" ]]; then
    echo "    Already exists, skipping."
    return
  fi

  mkdir -p "$(dirname "$path")"
  git clone $depth_flag -b "$branch" "$url" "$path" || \
    echo "    [WARN] Failed: $url"
}

for path in "${!PROJECTS[@]}"; do
  IFS='|' read -r name branch shallow remote_type <<< "${PROJECTS[$path]}"
  clone_project "$path" "$name" "$branch" "$shallow" "$remote_type"
done

echo ""
echo "Done."
