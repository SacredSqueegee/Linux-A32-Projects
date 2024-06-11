// factorial()
// 
// Description:
//      Computes the factorial of a given integer
//
// Parameters:
//      r0  -> integer input to compute factorial of
//
// Returns:
//      - r0 = r0! = factorial(input)
// 

.global factorial
factorial:
    // prologue
    push {fp, lr}
    mov fp, sp

    // Base case
    cmp r0, #0          // if input == 0
        moveq r0, #1    // 
        beq exit        // return 1

    // else, recurse
    push {r0}           // save r1 as it gets destroyed by function call

    sub r0, #1
    bl factorial        // factorial(input - 1)

    pop {r1}            // restore previous value
    mul r0, r1          // r0 = input * factorial(input - 1)
    

exit:
    // epilogue
    mov sp, fp
    pop {fp, pc}

