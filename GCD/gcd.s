.global main
.extern fopen, fprintf, fclose, printf, atoi

.section .data
filename: .asciz "nums.txt"
write_mode: .asciz "w"
format_str: .asciz "%d\n"

.section .text

print_num_to_file:
    push {lr}
    push {r0-r5}
    
    mov r5, r0

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
    mov r2, r5
    bl fprintf

    // Close the file
close_file:
    mov r0, r4
    bl fclose

    pop {r0-r5}
    pop {pc}

gcd:
    push {lr} 

    // Base case
    // if (b == 0) return a
    cmp r1, #0
    beq end_gcd
    
    // Recursive case
    // return gcd(b, a % b)
    
    // Compute a % b
    sdiv r2, r0, r1
    mul r3, r2, r1
    sub r4, r0, r3          // r4 now contains the modulus
    
    // Now compute gcd(b, a % b)
    mov r0, r1
    mov r1, r4
    bl gcd

end_gcd:
    pop {pc}

main:
    push {r4-r7, lr}

    // Check if argument count (argc) is correct
    cmp r0, #3             // Expecting 3 arguments (program name and two operands)
    blt exit

    // Convert argument strings to integers
    push {r1}
    ldr r0, [r1, #4]       // Load address of second argument (first operand)
    bl atoi                // Convert string to integer
    mov r4, r0
    pop {r1}
    
    push {r4}
    ldr r0, [r1, #8]       // Load address of third argument (second operand)
    bl atoi                // Convert string to integer
    mov r5, r0
    pop {r4}

    // Calculate the gcd of both operands
    mov r0, r4
    mov r1, r5
    bl gcd

    // Print gcd result to our file
    bl print_num_to_file

exit:
    // Exit
    mov r0, #0
    pop {r4-r7, pc}

.section .note.GNU-stack