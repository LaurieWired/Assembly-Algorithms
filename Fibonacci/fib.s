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

    // Base case: if n <= 1, return n
    cmp r0, #1
    ble end_fib

    // Recursive case: return fib(n - 1) + fib(n - 2); 
    push {r0}              // Save the current value of n
    sub r0, r0, #1
    bl fibonacci           // Recursive call fibonacci(n - 1)

    pop {r1}               // Restore the original n
    push {r0}              // Save fibonacci(n - 1)
    sub r1, r1, #2
    mov r0, r1
    bl fibonacci           // Recursive call fibonacci(n - 2)
    pop {r1}               // Get fibonacci(n - 1)

    add r0, r0, r1         // Add fibonacci(n - 1) + fibonacci(n - 2)

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


.section .note.GNU-stack
