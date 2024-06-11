// Sum of Squares
// 
// Description:
//      This program takes a given input array of bytes, square each
//      entry, then sum all entries together for the final result
//



.section .text

.global _start
_start:

print_hello_world:




exit:
    mov R0, #0                      @ return code
    mov R7, #1                      @ linux exit syscall
    svc 0                           @ software interrupt call exit

.section .data
// Out input array of bytes to square and then sum
inarr:      .byte   65,71,71,71,67,72,66,51,58,50
            .byte   60,60,55,64,52,69,52,67,55,69,0
            .set inarr_size, .-inarr
outstr:     .fill   11
