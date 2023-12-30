.global main
.extern fopen, fprintf, fclose, printf, atoi

.section .data
filename: .asciz "nums.txt"
write_mode: .asciz "w"
format_str: .asciz "%d\n"
format_str_result: .asciz "Fibonacci Number: %d\n"

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

fibonacci:
    push {lr} 

    // Replace this with your code! Return value goes in r0
    mov r0, #42

end_fib:
    pop {pc}

main:
    push {r4-r7, lr}

    // Check if argument count (argc) is correct
    cmp r0, #2             // Expecting 2 arguments (program name and n)
    blt exit

    // Convert argument string to integer
    ldr r0, [r1, #4]       // Load address of second argument (n value)
    bl atoi                // Convert string to integer
    mov r4, r0

    // Calculate the nth Fibonacci number
    mov r0, r4
    bl fibonacci

    // Print fib result to our file
    bl print_num_to_file

exit:
    // Exit
    mov r0, #0
    pop {r4-r7, pc}
