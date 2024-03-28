#!/bin/sh

TOP=`pwd`

INFOS_DIRECTORY=$TOP/infos
ROOTFS=$TOP/infos-user/bin/rootfs.tar
KERNEL=$INFOS_DIRECTORY/out/infos-kernel
KERNEL_CMDLINE="boot-device=ata0 init=/usr/init pgalloc.debug=0 pgalloc.algorithm=simple objalloc.debug=0 sched.debug=0 sched.algorithm=cfs $*"
QEMU=qemu-system-x86_64

if qemu-system-x86_64 -accel kvm 2>&1 | grep -q file; then
    ACCEL=""
else
    ACCEL="-accel kvm"
fi

echo "$QEMU -kernel $KERNEL -m 4G -serial null -debugcon file:trace.log -nographic -hda $ROOTFS -append \"$KERNEL_CMDLINE\""
timeout 3 unbuffer $QEMU -kernel $KERNEL -m 4G -serial null -debugcon file:/dev/stderr -nographic -hda $ROOTFS -append "$KERNEL_CMDLINE" || true
 
