# 32-bit RISC-V Kernel

A kernel built from scratch targeting 32-bit RISC-V (RV32). Runs in S-mode under OpenSBI, with cooperative multitasking and polling-based I/O.

## Features

- [ ] Multitasking
- [ ] Exception handler
- [ ] Paging
- [ ] System calls
- [ ] Device drivers
- [ ] File system
- [ ] Shell

## Source Structure

```
common.c / .h  - Shared library (printf, memset, ...)
kernel.c / .h  - Kernel core (processes, syscalls, drivers, fs)
kernel.ld      - Kernel linker script
shell.c        - Command-line shell
user.c / .h    - User-space library and syscall wrappers
user.ld        - User linker script
run.sh         - Build + run script
disk/          - File system contents
```

## Prerequisites

```sh
sudo apt install clang lld qemu-system-misc
```

## Building & Running

```sh
./run.sh
```

Builds `kernel.elf` and launches it in QEMU. To exit, press `Ctrl-A X`.

## OpenSBI

QEMU uses `-bios default` which loads a bundled OpenSBI automatically. To use a custom build:

**Install pre-built:**
```sh
sudo apt install opensbi
```

**Build from source (RV32):**
```sh
git clone https://github.com/riscv-software-src/opensbi.git
cd opensbi
make PLATFORM=generic CROSS_COMPILE=riscv32-unknown-elf- PLATFORM_RISCV_XLEN=32
```

Firmware blobs are output to `build/platform/generic/firmware/`. Use `fw_jump.bin` for development:

```sh
qemu-system-riscv32 -machine virt \
    -bios opensbi/build/platform/generic/firmware/fw_jump.bin \
    -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf
```

## Formatting

```sh
clang-format -i *.c *.h
```

Config: [.clang-format](.clang-format)
