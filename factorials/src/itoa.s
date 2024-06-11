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

// WARN: need to convert this pow macro to a function
//.include "pow.s"

.global itoa
itoa:
    // This is not a leaf function as we are calling more functions inside. So, we
    // need to setup the prolog accordingly
    push {fp, lr}           // Save FP and return addr on stack
    add fp, sp, #0          // Set the Frame Pointer(r11) to start of this functions frame
    sub sp, sp, #16         // Reserve 16-bytes of stack space for local vars/buffers
                            // SP must be 4-byte aligned at all times. At public interfaces
                            // SP must be two times the pointer size, i.e. 8-byte aligned

    str r0, [fp, #-4]       // Store output buffer address on stack as local var
    mov r4, r1              // r4 = #


    // Prepare for conversion
    push {r2-r7}            // Save 6 registers -> 48-bytes, to the stack that will be modified
    mov r5, #0              // r5 = x = 0
                            // r6 = y


    // TODO: use a different register for doing our 'r5 = (10^x) * 9' operation
    //       so that we can set r6 constant above and not have to reload it later

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

        // update # to: # - (y * 10^x)
        sub r4, r7

        // Store computed 'y' value as ascii char to outstr
        add r6, #0x30       // convert base-10 to ascii
        //strb r3, [r0], #1   // Save char to outstr, inc to next str location
        testing:
        ldr r0, [fp, #-4]
        strb r6, [r0], #1
        str r0, [fp, #-4]

        // check if we are done, if not -> prepare for next loop and repeate
        sub r5, #1          // dec x
            cmp r5, #0
            blt done        // if x < 0 -> goto done
        b loop_1_done       // goto loop_t


// NOTE: Leaving done label below just in case we want to do something in the future before
//       exiting the function
done:
exit:
    // Function epilog
    pop {r2-r7}             // Restore our 6 registers we saved earlier
    sub sp, fp, #0          // Move stack pointer to original position before function
    pop {fp, pc}            // Restore frame pointer and move lr to pc to exit function

