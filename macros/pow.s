//@@@@@@
//@   Outputs (base ^ exp) in dest
//@
//@   Parameters:
//@       - does NOT take immediates, must be registers
//@       dest  -> reg to store result in
//@       base  -> reg representing base     (unsigned)
//@       exp   -> reg representing exponent (unsigned)
//@
//@   Registers:
//@       r0  -   computed power
//@       r1  -   base
//@       r2  -   exp
//@
//@   labels: 
//@       1: multiplication loop
//@       2: done
//@@@@@@


// TODO: Add error handling
//          - Make sure that output doesn't overflow


.macro pow dest, base, exp

    mov \dest, \base    // update return value with base value

    // if this is NOT a special case (exp = 0/1) goto mul loop
    cmp \exp, #2
    bge 1f              // if (exp >= 2) -> goto multiplication loop

    // else (exp < 2), handle special cases
    cmp \exp, #0         // if (exp == 0) -> return 1
    moveq \dest, #1
                        // else exp must equal 1 if we get here and
    b 2f                // as dest is already set to base we can exit

    // Multiplication Loop
    1:
        mul \dest, \base
        sub \exp, #1
        cmp \exp, #2
        blt 2f              // if (exp < 2) -> goto done
        b 1b                // else, loop and mul. again

    // done
    2:

.endm

