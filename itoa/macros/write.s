//@@@@@@
//@   Outputs a null terminated string to stdout
//@
//@   r0  -   #1 -> stdout / scratch register during str len calc
//@   r1  -   address represented by arg1
//@   r2  -   str length, not including null char
//@   r7  -   #4 -> write()
//@
//@   labels: 
//@       1: Str Length loop 
//@       2: Write syscall 
//@@@@@@

.macro  write   string

    // Load string addr and starting char count
    ldr r1, =\string
    mov r2, #0

    // Find string length
    1:
        ldrb r0, [r1, r2]   // current char to cmp
        cmp r0, #0
        beq 2f

        add r2, #1          // keep looping till we hit null byte
        b 1b


    // Print string to stdout
    2:
        mov r0, #1      // stdout -> 1
                        // r1 -> string addr; already set
                        // r2 -> string len; already set
        mov r7, #4      // write()
        svc #0

.endm

