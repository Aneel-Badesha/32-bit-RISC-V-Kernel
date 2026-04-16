# 32-bit RISC-V Kernel

A kernel built from scratch targeting 32-bit RISC-V (RV32). Runs in S-mode under OpenSBI, with multitasking, virtual memory, system calls, a virtio block driver, a TAR-based filesystem, and an interactive shell.

## Features

- [x] Boots RV32 kernel in S-mode under OpenSBI
- [x] SBI console I/O (`putchar`, `getchar`)
- [x] Common runtime helpers (`memset`, `memcpy`, `strcpy`, `strcmp`, `printf`)
- [x] Trap entry/exit with full register save/restore (`kernel_entry`)
- [x] System calls: `exit`, `putchar`, `getchar`, `readfile`, `writefile`
- [x] Early physical page allocator (`alloc_pages`)
- [x] SV32 two-level paging (`map_page`)
- [x] Process management and round-robin scheduler (`create_process`, `yield`)
- [x] User-mode execution (U-mode via `sret`)
- [x] Virtio-blk device driver
- [x] TAR-based in-memory filesystem with disk persistence
- [x] Interactive shell (`hello`, `readfile`, `writefile`, `exit`)
- [ ] Timer interrupts / preemption
- [ ] Inter-process communication
- [ ] Dynamic process creation from user space
- [ ] Interrupt-driven I/O
- [ ] Page reclamation / swap

## Source Structure

```
common.c / .h      - Shared library (printf, memset, ...) — used by kernel and user
kernel.h           - Cross-cutting kernel types, macros (PANIC, READ_CSR), shared structs
kernel.ld          - Kernel linker script

sbi.c / .h         - SBI console interface (putchar, getchar, sbi_call)
mm.c / .h          - Physical allocator and SV32 paging (alloc_pages, map_page)
trap.c / .h        - Trap entry and syscall dispatch (kernel_entry, handle_trap)
proc.c / .h        - Process management and scheduler (create_process, yield)
virtio.c / .h      - Virtio-blk device driver (virtio_blk_init, read_write_disk)
fs.c / .h          - TAR filesystem (fs_init, fs_lookup, fs_flush)
main.c             - Kernel entry point (kernel_main, boot)

shell.c            - Interactive user-space shell
user.c / .h        - User-space syscall wrappers (putchar, getchar, readfile, writefile)
user.ld            - User linker script

run.sh             - Build + run script (outputs to build/)
disk/              - Filesystem contents (packed into build/disk.tar at build time)
docs/              - Design notes and reference material
build/             - All build artifacts (*.elf, *.bin, *.map, disk.tar, qemu.log)
```

## Prerequisites

```sh
sudo apt install clang lld qemu-system-misc
```

## Building & Running

```sh
./run.sh
```

Compiles everything and launches `build/kernel.elf` in QEMU. To exit, press `Ctrl-A X`.

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
    -kernel build/kernel.elf
```

## Formatting

```sh
clang-format -i *.c *.h
```

Config: [.clang-format](.clang-format)
