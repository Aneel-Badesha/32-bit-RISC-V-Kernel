# 32-bit RISC-V Kernel

A kernel built from scratch targeting 32-bit RISC-V (RV32). Runs in S-mode under OpenSBI, with early trap handling, page allocation, and polling-based SBI console I/O.

## Features

- [x] Boots RV32 kernel in S-mode under OpenSBI
- [x] SBI console output (`putchar`)
- [x] Common runtime helpers (`memset`, `memcpy`, `strcpy`, `strcmp`)
- [x] Minimal `printf` (`%d`, `%x`, `%s`, `%%`)
- [x] Trap entry/exit path with register save/restore (`kernel_entry`)
- [x] Basic trap handling (`handle_trap`, panic on unexpected trap)
- [x] Early page allocator (`alloc_pages`)
- [x] Linker-defined kernel memory layout (BSS, stack, free RAM)
- [ ] Multitasking/scheduler
- [ ] User-mode programs (U-mode)
- [ ] System calls
- [ ] Full exception/interrupt handling
- [ ] Timer interrupts/preemption
- [ ] Paging
- [ ] Device drivers (beyond SBI console)
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
