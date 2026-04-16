#pragma once
#include "kernel.h"

void kernel_entry(void);
void handle_trap(struct trap_frame *f);
