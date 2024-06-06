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
    // Check for special case of exp=0
    cmp \exp, #0
    bne 1f              // if (exp != 0) -> goto multiplication loop

    // Set dest to 1, return
    mov \dest, #1
    b 3f

    // pre mul. loop setup
    1:
    mov \dest, \base        // dest is at least equal to the base

    // Multiplication Loop
    2:
        // Check exp, if after decrementing exp = 0 we are done
        sub \exp, #1
        cmp \exp, #0
        beq 3f              // done

        mul \dest, \base
        b 2b                // repeat

    // done
    3:

.endm

