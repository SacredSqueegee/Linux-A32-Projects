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

    // Registers:
    // r4 -> addr of inarr
    // r5 -> addr of outstr
    // r6 -> accumulated total
    // r7 -> current array entry / read number
    // r8 -> loop/remaining index counter

    // Initialize registers
    ldr r4, =inarr
    ldr r5, =outstr
    mov r6, #0
    mov r8, #inarr_size         // Loop counter, init to size of array

    loop:
        ldrb r7, [r4], #1       // Load current array value to r1, inc to next index after
        mla r6, r7, r7, r6      // r0 = (r1 * r1) + r0 = r1^2 + r0

        sub r8, #1              // dec remaining indexes/loop counter
        cmp r8, #0              // if 0, ther are no more remaining array entries
        bne loop                // repeat if not 0, we have more array entries
        
    
done:
    // Convert our answer to ascii
    mov r0, r5
    mov r1, r6
    bl itoa

    // Write our answer to terminal
    mov r0, r5
    bl writeln


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

