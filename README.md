# 32-bit RISC-V Kernel

## Overview

This project implements a Kernel from scratch on 32-bit RISC-V (RV32). The ISA was chosen for its simplicity and widespread use in embedded/firmware development.

## Platform

- **ISA:** 32-bit RISC-V (RV32)
- **CPU Modes:** M-mode (OpenSBI/BIOS), S-mode (kernel), U-mode (user applications)
- **Multitasking:** Cooperative (processes voluntarily yield the CPU)
- **Memory model:** Single processor, polling-based I/O (no interrupt-driven I/O)

## Features

**Planned:**
- [ ] Multitasking — switch between processes to share the CPU
- [ ] Exception handler — handle events requiring OS intervention
- [ ] Paging — isolated memory address space per application
- [ ] System calls — allow applications to invoke kernel features
- [ ] Device drivers — abstract hardware (disk read/write, etc.)
- [ ] File system — manage files on disk
- [ ] Command-line shell — user interface

## Source Structure

```
├── disk/      - File system contents
├── common.c   - Kernel/user common library (printf, memset, ...)
├── common.h   - Kernel/user common library (struct and constant definitions)
├── kernel.c   - Kernel: process management, system calls, device drivers, file system
├── kernel.h   - Kernel: struct and constant definitions
├── kernel.ld  - Kernel linker script (memory layout)
├── shell.c    - Command-line shell
├── user.c     - User library: system call wrappers
├── user.h     - User library: struct and constant definitions
├── user.ld    - User linker script (memory layout)
└── run.sh     - Build script
```

## Building & Running

```sh
./run.sh
```

## Formatting

Uses `clang-format` (v19, LLVM-based style). To format all source files:

```sh
clang-format -i *.c *.h
```

Config is in [.clang-format](.clang-format).
