.global main
.extern fopen, fprintf, fclose, printf, atoi, sleep

.section .data
format_str_depth: .asciz "Depth: %d\n"
format_str_sp: .asciz "Stack pointer: %p\n"
filename: .asciz "original_sp.txt"
filename_latest_sp: .asciz "latest_sp.txt"
write_mode: .asciz "w"
format_str: .asciz "%p\n"

.section .text

print_original_sp_to_file:
    push {lr}
    push {r0-r5}

    // Open the file for writing
    ldr r0, =filename
    ldr r1, =write_mode
    bl fopen
    mov r4, r0               // Store the file pointer in r4

    // Check if fopen succeeded
    cmp r4, #0
    beq close_file

    // Write the number to the file
    mov r0, r4
    ldr r1, =format_str
    mov r2, sp
    bl fprintf

// Close the file
close_file:
    mov r0, r4
    bl fclose

    pop {r0-r5}
    pop {pc}

print_latest_sp_to_file:
    push {lr}
    push {r0-r5}

    // Open the file for writing
    ldr r0, =filename_latest_sp
    ldr r1, =write_mode
    bl fopen
    mov r4, r0               // Store the file pointer in r4

    // Check if fopen succeeded
    cmp r4, #0
    beq close_file_latest

    // Write the number to the file
    mov r0, r4
    ldr r1, =format_str
    mov r2, sp
    bl fprintf
    
// Close the second file
close_file_latest:
    mov r0, r4
    bl fclose

    pop {r0-r5}
    pop {pc}

recurse:
    push {lr}
    
    push {r0}   // Saving the depth argument
    // Print depth to the console
    mov r1, r0
    ldr r0, =format_str_depth
    bl printf
    pop {r0}
        
    // Only print to the file every 1000 levels to help with perf
    // Check if depth is divisible by 1000 and print if so
    push {r0}   // Saving the depth argument
    
    // Compute the modulus to see if there is remainder
    mov r1, #1000
    sdiv r2, r0, r1
    mul r3, r2, r1
    sub r4, r0, r3
    cmp r4, #0
    bne skip_sp_print // We only want to print every 1000 times so skip this one
    
    bl print_latest_sp_to_file
    
skip_sp_print:
    // Print stack pointer to the console
    mov r1, sp
    ldr r0, =format_str_sp
    bl printf
    
    pop {r0}
    
    // Increase depth by 1 before recursing
    
    // Your code goes here!
    
recurse_exit:
    pop {pc}

main:
    push {r4-r7, lr}
    
    bl print_original_sp_to_file

    // Call recurse until we cause a stack overflow
    mov r0, #1
    bl recurse
    
exit:
    // Exit
    mov r0, #0
    pop {r4-r7, pc}
    
    
.section .note.GNU-stack

