.section .text
// ================================================================================
.include "write.s"


// input number 
.equ    basenum, 209867295


.global _start
_start:

    ldr r0, =outstr
    ldr r1, =basenum
    bl itoa

// Display our converted number, then exit
done:
    // WARN: Need to figure out how output is going to work
    write outstr

    // Print newline char
    ldr r0, =outstr         // Need to reload outstr as it is not preserved
    mov r1, #0x000a         // r1 = '\0', '\n'; gets stored in memroy as -> '\n', '\0'
    strh r1, [r0]           // load halfword 0x000a into outstr
    write outstr
    

exit:
    mov R0, #0                      @ return code
    mov R7, #1                      @ linux exit syscall
    svc 0                           @ software interrupt call exit

.section .data
// ================================================================================
outstr:     .fill 11        @ the max output size is 10 digits 
                            @ 11 for line ending 

