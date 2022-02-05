#!/bin/bash

set -e -o pipefail

pushd $CACHE_DIR

# Get the kernel
filename=rpi4-rt-kernel-${LINUX_RT_VERSION}.zip
if [ ! -f $filename ]; then
  wget --progress=dot -e dotbytes=10M -O $filename https://github.com/ros-realtime/rt-kernel-docker-builder/releases/download/v${LINUX_RT_VERSION}-raspi-arm64-lttng/RPI4.RT.Kernel.deb.packages.zip
fi

unzip $filename

# Do not install the debug symbols as this causes an additional 3GB of storage
# needed, which is will cause us to go over the 2GB limit for Github releases.
rm linux*dbg*.deb
ls -l

# These deb files will be installed by the phase1 script.
# The /setup folder in the chroot will be deleted by phase2 script
cp linux-*.deb $CHROOT_PATH/setup/
rm linux-*.deb

echo "PINNED_CPU_FREQUENCY=${PINNED_CPU_FREQUENCY}" > $CHROOT_PATH/etc/default/cpu-frequency

popd
