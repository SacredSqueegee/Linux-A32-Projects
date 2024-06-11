// itoa()
// 
// Description:
//      Converts a given integer to its ascii representation
//
// Parameters:
//      r0  -> address to buffer to write the converted ascii
//             characters to. It is the Callee's responsibility
//             to make sure that the buffer is big enough to
//             write the whole converted integer to. Note: the
//             largest buffer needed is 11-bytes (10-bytes for 
//             the characters and 1-byte for the null termination)
//      r1  -> 32-bit unsigned word to convert to ascii
//
// Returns:
//      - This function returns the ascii conversion of the uint_32
//        in r0 inside the buffer pointed to by r1.
// 

/*
NOTE: Future Expansions:
    - Convert to library function for later use or macro
    - Add error checking
    - Add test cases
    - Clean code up and remove unecessary instruction
        - Some instructions have already been commented out
    - Optimize solution???
        - What is the best way to do this?
        - This was a result of me working out a solution by hand on paper
          surley there is a better way?
*/

// NOTE: Internal register and stack space use
//  r4 -> #
//  r5 -> x
//  r6 -> y
//  r7 -> temp
//  [fp, #-4]   -> output buffer address
//

.global itoa
itoa:
    // This is not a leaf function as we are calling more functions inside. So, we
    // need to setup the prolog accordingly
    push {fp, lr}           // Save FP and return addr on stack
    mov fp, sp              // Set the Frame Pointer(r11) to start of this functions frame
    sub sp, sp, #16         // Reserve 16-bytes of stack space for local vars/buffers
                            // SP must be 4-byte aligned at all times. At public interfaces
                            // SP must be two times the pointer size, i.e. 8-byte aligned

    str r0, [fp, #-4]       // Store output buffer address on stack as local var
    mov r4, r1              // r4 = #

    // Prepare for conversion
    push {r2-r7}            // Save 6 registers -> 48-bytes, to the stack that will be modified
    mov r5, #0              // r5 = x = 0
                            // r6 = y


    // Find x so that [# <= (9 * 10^x)]
    // We only need to do this once as we just need the largest 'x'. then
    // we can decrment 'x' till done in our loop_2 below
    loop_1:
        // compute (9 * 10^x)
        mov r0, #10         // base = 10
        mov r1, r5          // exp = x
        bl pow              // 10^x
        mov r1, #9
        mul r0, r1          // r0 = (10^x) * 9

        // Do comparison of # and (9 * 10^x)
        cmp r4, r0
        ble loop_1_done     // if (# <= (9 * 10^x)) -> goto loop_1_done
                            // else -> go on below
        add r5, #1          // inc x
        b loop_1            // repeat

    
    loop_1_done:
        mov r6, #0          // r6 = y = 0
        mov r7, #0          // r6 = temp = 0


    // Find y so that [# >= (y * 10^x)]
    loop_2:
        // compute y * 10^x
        mov r0, #10         // base = 10
        mov r1, r5          // exp = x
        bl pow              // r0 = 10^x
        mul r0, r6          // r0 = (10^x) * y

        // Do comparison of # and (y * 10^x)
        cmp r4, r0
        blt loop_2_done     // if (# < (9 * 10^x)) -> goto loop_2_done
                            // else -> go on below
        add r6, #1          // inc y
        mov r7, r0          // save prev. (y*10^x) computation for when we finish
                            // loop_2 and need the previous value
        b loop_2            // repeat
        

    // Convert 'y' to ascii, store, check and prepare for next loop if needed
    loop_2_done:
        sub r6, #1          // When loop_2 finishes we overshoot the number by 1
                            // so sub 1 to compensate

        sub r4, r7          // update # to: # - (y * 10^x)

        add r6, #0x30       // convert base-10 to ascii

        // Store computed 'y' value as ascii char to outstr
        ldr r0, [fp, #-4]   // r0 = addr of output buffer
        strb r6, [r0], #1   // store converted digit to output buffer
        str r0, [fp, #-4]   // update output buffer pointer to the new incremented one

        // check if we are done, if not -> prepare for next loop and repeate
        sub r5, #1          // dec x
            cmp r5, #0
            blt exit        // if x < 0 -> goto exit
        b loop_1_done       // goto loop_t


exit:
    // Function epilog
    pop {r2-r7}             // Restore our 6 registers we saved earlier
    mov sp, fp              // Move stack pointer to original position before function
    pop {fp, pc}            // Restore frame pointer and move lr to pc to exit function

