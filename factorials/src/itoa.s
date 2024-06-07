// itoa()
// 
// Description:
//      Converts a given integer to its ascii representation
//
// Parameters:
//      r0
//

/*
Future Expansions:
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
.include "pow.s"

.global itoa
itoa:

    ldr r0, =outstr         // r0 = outstr start addr
    // WARN: Need to fix organization of register parameters
    //       right now r1 is the input number
    ldr r1, =basenum        // r1 = #
    mov r2, #0              // r2 = x = 0
                            // r3 = y


    // TODO: use a different register for doing our 'r5 = (10^x) * 9' operation
    //       so that we can set r6 constant above and not have to reload it later

    // Find x so that [# <= (9 * 10^x)]
    // We only need to do this once as we just need the largest 'x'. then
    // we can decrment 'x' till done in our loop_2 below
    loop_1:
        // compute (9 * 10^x)
        mov r6, #10         // base = 10
        mov r7, r2          // exp = x
        pow r5, r6, r7      // r5 = 10 ^ x

        mov r6, #9
        mul r5, r6          // r5 = (10^x) * 9

        // Do comparison of # and (9 * 10^x)
        cmp r1, r5
        ble loop_1_done     // if (# <= (9 * 10^x)) -> goto loop_1_done
                            // else -> go on below
        add r2, #1          // inc x
        b loop_1            // repeat

    
    loop_1_done:
        mov r3, #0          // r3 = y = 0
        mov r6, #10         // r6 -> base = 10; Does not change from here on


    // Find y so that [# >= (y * 10^x)]
    loop_2:
        // compute y * 10^x
        //mov r6, #10         // base = 10
        // r6 set at loop_1_done, and is not modified
        mov r7, r2          // exp = x
        pow r5, r6, r7      // r5 = 10 ^ x

        mul r5, r3          // r5 = (10^x) * y

        // Do comparison of # and (y * 10^x)
        cmp r1, r5
        blt loop_2_done     // if (# < (9 * 10^x)) -> goto loop_2_done
                            // else -> go on below
        add r3, #1          // inc x
        b loop_2            // repeat
        

    // Convert 'y' to ascii, store, check and prepare for next loop if needed
    loop_2_done:
        sub r3, #1          // When loop_2 finishes we overshoot the number by 1
                            // so sub 1 to compensate

        // re-compute y * 10^x with correct y value from above
        // TODO: could probably store previous (y * 10^x) value from above so we
        //       don't have to recompute it again here

        //mov r6, #10         // base = 10
        // r6 set at loop_1_done, and is not modified
        mov r7, r2          // exp = x
        pow r5, r6, r7      // r5 = 10 ^ x

        mul r5, r3          // r5 = (10^x) * y

        // compute: # - (y * 10^x)
        sub r1, r5

        // Store computed 'y' value as ascii char to outstr
        add r3, #0x30       // convert base-10 to ascii
        strb r3, [r0], #1   // Save char to outstr, inc to next str location

        // check if we are done, if not -> prepare for next loop and repeate
        sub r2, #1          // dec x
            cmp r2, #0
            blt done        // if x < 0 -> goto done
        mov r3, #0          // y = 0
        b loop_2            // goto loop_t


// Display our converted number, then exit
done:
    // WARN: Need to figure out how output is going to work
    write outstr

    // Print newline char
    ldr r0, =outstr         // Need to reload outstr as we have been incrementing it
    mov r1, #0x000a         // r1 = '\0', '\n'; gets stored in memroy as -> '\n', '\0'
    strh r1, [r0]           // load halfword 0x000a into outstr
    write outstr

exit:
    // WARN: do return stuff here...

