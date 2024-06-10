// pow()
// 
// Description:
//      Computes the power of a given number.
//      Formula: (base ^ exp) -> r0
// 
// Parameters:
//      r0 -> base
//      r1 -> exp
// 
// Returns:
//      - returns the expression (base ^ exp) in r0
// 


// TODO: Add error handling
//          - Make sure that output doesn't overflow

.global pow
pow:
    push {fp}               // Save old frame pointer
    add fp, sp, #0          // Set up new frame pointer location
    push {r2}               // Save r2 as it is not being as a parameter but is need
                            // as a scratch register


    // Check for special case of exp=0
    cmp r1, #0
    bne pre_multiply_loop   // if (exp != 0) -> goto multiplication loop

    // Set dest to 1, return
    mov r0, #1
    b done

    // pre mul. loop setup
    pre_multiply_loop:
        mov r2, r0          // make copy of base number for multiplying later in loop

    // Multiplication Loop
    multiply_loop:
        // Check exp, if after decrementing exp = 0 we are done
        sub r1, #1
        cmp r1, #0
        beq done            // done

        mul r0, r2          // result = result(r0) * base(r2)
        b multiply_loop     // repeat


done:
exit:
    pop {r2}                // Restore r2
    add sp, fp, #0          // Re-adjust sp to original location
    pop {fp}                // restore original frame pointer
    bx lr                   // Jump back to callee via LR register


