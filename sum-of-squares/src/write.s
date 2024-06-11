.section .text
.global write
.global writeln


// write()
// 
// Description:
//      writes a null terminated string to stdout. Assumes stack is already 8-byte
//      aligend with called.
//
// Parameters:
//      r0  -> address of null terminated string
//
// Returns:
//      - none, writes string to stdout
// 
write:
    // prologue, non leaf
    push {r11, lr}          // Save fp and lr
    mov r11, sp             // setup fp
    // as we pushed 2 registers stack is 8-byte aligned already 2 * (4-bytes / reg)

    // compute string length
    mov r1, r0              // mov string addr to r1
    mov r2, #0              // zero string length

    // Length loop
    1:
        ldrb r0, [r1, r2]   // current char to check for null
        cmp r0, #0
        beq 2f              // Founc null termination if 0, stop

        add r2, #1          // increment to next char
        b 1b

    // Call write() syscall and print to stdout
    2:
        mov r0, #1          // stdout -> 1
                            // r1 -> string addr; already set
                            // r2 -> string len; already set
        mov r7, #4          // write() syscall #
        svc #0

    // Exit epilogue, non leaf
    mov sp, r11             // reset sp
    pop {r11, pc}           // reset fp and set pc to initial lr


// writeln()
// 
// Description:
//      writes a null terminated string to stdout and generates a new line.
//      This function is just a wrapper around write() with extra functionality.
//      Assumes stack is 8-byte aligned when called
//
// Parameters:
//      r0  -> address of null terminated string
//
// Returns:
//      - none, writes string to stdout with new line at end
// 
writeln:
    // prologue, non leaf
    push {r11, lr}          // Save fp and lr
    mov r11, sp             // setup fp


    bl write

    sub sp, #8              // Allocate 8-bytes of stack space or newline string
                            // we only need 2-bytes but we need to keep stack 8-byte
                            // aligned as write makes a public interface call
    sub r0, r11, #8         // Load r0 with addr of our local 8-byte buffer; fp-8

    mov r1, #0x000a         // r1 = '\0', '\n'; stored in memory as '\n', '\0'
    strh r1, [r0]           // store newline str in our local buffer

                            // r0 already contains address of string
    bl write                // write newline to stdout


    // Exit epilogue, non leaf
    mov sp, r11             // reset sp
    pop {r11, pc}           // reset fp and set pc to initial lr

