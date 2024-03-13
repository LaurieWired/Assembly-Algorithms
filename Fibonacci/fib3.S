.file "fib3.S"
.section .note.GNU-stack
.extern printf, atoi, calloc, free

//
//  Expected Compile Command: gcc -o fib3 fib3.S
//
//  Program Enty: main
//
//  Purpose: Print the n'th fibonacci term to standard output
//  Usage: ./fib3 n
//
//         n = Fibinacci term to output\n"
//


.data
.section .rodata

format_str_result: .asciz "Fibonacci Number: %llu\n"
usage_txt: .asciz "Usage: ./fib3 n \n\n\
      n = Fibonacci term to output.  Must be positive number.\n\n"

.text

fibonacci: // %rsi = fibanocci_sequence ( %rsi'th term) BORKS %rdi, %rcx, %rdx
	// Base case: if n<=1, return n
	cmp $1, %rsi
	jle end_fib	

	// Get enough memory to cover the fib sequence with calloc
	movq $8, %rdi
	push %rsi
	inc %rsi    // Need n+1 memory, because there's a 0th term needing accounting for.
	call calloc // %rax = calloc( %rdi, %rsi)
	pop %rsi

	// Check if calloc Failed
	cmp $0, %rax
	jle exit

	// Save calloc location a little out of way for indirect addressing.
	movq %rax, %rdx

	// Populate initial values
	movq $0, (%rax)
	movq $1, 8(%rax)
	movq $2, %rcx

fib_loop: 
	// fib (n) = fib(n-1) + fib(n-2)
	// 	Counter %rcx starts at 2 until desired n.
	// 	Iterate until desired n (%rsi).
	//	%rax is a moving pointer for reading prior sequence locations in the heap.
	//	(%rdx,%rcx,8) is indirect address to fib(n)

	// Copy fib(n-2) -> fib(n)
	movq (%rax), %rdi
	movq %rdi, (%rdx,%rcx,8)
	add $8, %rax

	// Add fib (n-1) to fib(n-2) at fib(n) locaton.
	movq (%rax), %rdi
	add %rdi, (%rdx,%rcx,8)

	//Check that counter is less than ultimate desired, and if so iterate.
	//If allowed to increment past, there will be no memory there.
	cmp %rsi, %rcx
	jge fib_finalize

	//Iterate.
	inc %rcx
	jmp fib_loop

fib_finalize:
	pushq (%rdx,%rcx,8) // Save the result
	movq %rdx, %rdi
	call free  // ***  See!?  ***
	popq %rsi //Put result in expected location

end_fib:
	ret


print_fib: 
	xorq %rax, %rax //Cause the internet said you had to.
	leaq format_str_result(%rip), %rdi
	call printf     // printf( %rdi, %rsi)
	ret

usage_msg:
	xorq %rax, %rax
	leaq usage_txt(%rip), %rdi
	call printf
	jmp exit

.global main
main:
	//Expecting 2 arguments, otherwise exit.
	cmpq $2, %rdi  //Check if argc is correct
	jne usage_msg

	//Convert argument string to integer
	addq $8, %rsi //argv[1]
	movq (%rsi), %rdi // Load address of argv[1]
	call atoi // %rax = atoi(  (char*)%rdi )

	//Run Fibonacci algorithm
	movq %rax, %rsi
	cmp $0, %rsi
	jl usage_msg

	call fibonacci  // fibonacci('n' = %rsi)
	
	call print_fib  // Output the result

exit:
	mov $231, %rax
	mov $0, %rsi
	syscall
