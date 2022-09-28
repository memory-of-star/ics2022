	.file	"condition_move1.c"
	.text
	.globl	f1
	.type	f1, @function
f1:
.LFB0:
	.cfi_startproc
	addq	$1, %rdi
	leaq	-1(%rsi), %rax
	cmpq	%rax, %rdi
	cmovge	%rdi, %rax
	ret
	.cfi_endproc
.LFE0:
	.size	f1, .-f1
	.globl	f2
	.type	f2, @function
f2:
.LFB1:
	.cfi_startproc
	movq	(%rdi), %rdx
	movq	(%rsi), %rax
	cmpq	%rax, %rdx
	jg	.L5
	leaq	-1(%rax), %rdx
	movq	%rdx, (%rsi)
	ret
.L5:
	leaq	-1(%rdx), %rax
	movq	%rax, (%rdi)
	ret
	.cfi_endproc
.LFE1:
	.size	f2, .-f2
	.globl	f3
	.type	f3, @function
f3:
.LFB2:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.L7
	movq	(%rdi), %rax
	ret
.L7:
	movl	$0, %eax
	testq	%rsi, %rsi
	je	.L6
	movq	(%rsi), %rax
.L6:
	rep ret
	.cfi_endproc
.LFE2:
	.size	f3, .-f3
	.globl	f4
	.type	f4, @function
f4:
.LFB3:
	.cfi_startproc
	leaq	1(%rsi), %rax
	cmpq	%rsi, %rdi
	cmovg	%rdi, %rax
	ret
	.cfi_endproc
.LFE3:
	.size	f4, .-f4
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
