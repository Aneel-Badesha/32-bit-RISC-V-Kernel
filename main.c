#include "kernel.h"
#include "trap.h"
#include "proc.h"
#include "virtio.h"
#include "fs.h"

extern char __bss[], __bss_end[], __stack_top[];
extern char _binary_shell_bin_start[], _binary_shell_bin_size[];

void kernel_main(void)
{
    // set the bss section to 0
    memset(__bss, 0, (size_t)__bss_end - (size_t)__bss);
    WRITE_CSR(stvec, (uint32_t)kernel_entry);
    virtio_blk_init();
    fs_init();

    char buf[SECTOR_SIZE];
    read_write_disk(buf, 0, false);
    printf("first sector: %s\n", buf);

    strcpy(buf, "hello from kernel!!!\n");
    read_write_disk(buf, 0, true);

    idle_proc = create_process(NULL, 0);
    idle_proc->pid = 0;
    current_proc = idle_proc;

    create_process(_binary_shell_bin_start, (size_t)_binary_shell_bin_size);

    yield();
    PANIC("switched to idle process");
}

__attribute__((section(".text.boot"))) __attribute__((naked)) void boot(void)
{
    __asm__ __volatile__(
        "mv sp, %[stack_top]\n" // set the stack pointer
        "j kernel_main\n"       // jump to the kernel main function
        :
        : [stack_top] "r"(__stack_top) // pass the stack top address as %[stack_top]
    );
}
