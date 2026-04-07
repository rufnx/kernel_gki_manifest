```
curl -LSs https://raw.githubusercontent.com/rufnx/kernel_gki_manifest/main/gki-5.10.sh | bash -s "1"
```
# How To Build
1. create directory gki kernel
   ```
   mkdir gki && cd gki
   ```
2. run this scripts manifest
3. for build kernel gki:
   ```
   LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh
   ```
# Notes
for variant LTO:
  1. none
  2. thin
  3. full
