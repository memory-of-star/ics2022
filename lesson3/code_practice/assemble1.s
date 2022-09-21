	.file	"assemble1.c"
	.text
	.globl	to_digit
	.type	to_digit, @function
to_digit:
.LFB23:
	.cfi_startproc
	movl	(%rdi), %eax
	movl	$0, (%rdi)
	leal	48(%rax), %eax
	ret
	.cfi_endproc
.LFE23:
	.size	to_digit, .-to_digit
	.globl	foo
	.type	foo, @function
foo:
.LFB24:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, 12(%rsp)
	leaq	12(%rsp), %rdi
	call	to_digit
	movsbl	%al, %edi
	call	_putchar@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE24:
	.size	foo, .-foo
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
