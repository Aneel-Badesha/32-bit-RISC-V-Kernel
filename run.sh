#!/bin/bash
set -xue

# QEMU file path
QEMU=qemu-system-riscv32

# Path to clang and compiler flags
CC=clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fuse-ld=lld -fno-stack-protector -ffreestanding -nostdlib"

OBJCOPY=llvm-objcopy

BUILD=build
mkdir -p "$BUILD"

# Build the shell (application)
$CC $CFLAGS -Wl,-Tuser.ld -Wl,-Map="$BUILD/shell.map" -o "$BUILD/shell.elf" shell.c user.c common.c
$OBJCOPY --set-section-flags .bss=alloc,contents -O binary "$BUILD/shell.elf" "$BUILD/shell.bin"
# Run objcopy from inside build/ so the embedded symbol names stay _binary_shell_bin_*
(cd "$BUILD" && $OBJCOPY -Ibinary -Oelf32-littleriscv shell.bin shell.bin.o)

# Build the kernel
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map="$BUILD/kernel.map" -o "$BUILD/kernel.elf" \
    main.c sbi.c mm.c trap.c proc.c virtio.c fs.c common.c "$BUILD/shell.bin.o"

(cd disk && tar cf ../"$BUILD/disk.tar" --format=ustar *.txt)

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
    -d unimp,guest_errors,int,cpu_reset -D "$BUILD/qemu.log" \
    -drive id=drive0,file="$BUILD/disk.tar",format=raw,if=none \
    -device virtio-blk-device,drive=drive0,bus=virtio-mmio-bus.0 \
    -kernel "$BUILD/kernel.elf"