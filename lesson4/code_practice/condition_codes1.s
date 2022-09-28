	.file	"jump_instruction1.c"
	.text
	.globl	print_b
	.type	print_b, @function
print_b:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, -8(%rbp)
	movq	$32, -16(%rbp)
	jmp	.L2
.L5:
	movq	-16(%rbp), %rax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movl	%edx, %ecx
	shrq	%cl, %rax
	andl	$1, %eax
	testq	%rax, %rax
	je	.L3
	movl	$49, %eax
	jmp	.L4
.L3:
	movl	$48, %eax
.L4:
	movl	%eax, %edi
	call	putchar@PLT
.L2:
	movq	-16(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -16(%rbp)
	testq	%rax, %rax
	jne	.L5
	movl	$10, %edi
	call	putchar@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	print_b, .-print_b
	.globl	main
	.type	main, @function


print_flag:
	pushf
	movl	(%rsp), %edi
	popf
	call	print_b
	ret


main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	movl    $4000000000, %eax
	movl    $4000000000, %edi
	add     %edi, %eax
	call    print_flag          ;use this function to print current flag
	movl    $2000000000, %eax
	movl    $2000000000, %edi 
	add     %edi, %eax
	call    print_flag        
	movl    $2000000000, %eax
	movl    $2000000000, %edi
	sub     %edi, %eax
	call    print_flag
	movl	$0, %eax
	leave
	ret
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
