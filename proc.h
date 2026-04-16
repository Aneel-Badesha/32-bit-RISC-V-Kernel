#pragma once
#include "kernel.h"

extern struct process procs[PROCS_MAX];
extern struct process *current_proc;
extern struct process *idle_proc;

void switch_context(uint32_t *prev_sp, uint32_t *next_sp);
struct process *create_process(const void *image, size_t image_size);
void yield(void);
