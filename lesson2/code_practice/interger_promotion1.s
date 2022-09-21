	.file	"interger_promotion1.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d %d\n"
.LC1:
	.string	"%d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movb	$-128, -2(%rbp)
	movb	$-128, -1(%rbp)
	movzbl	-2(%rbp), %edx
	movsbl	-1(%rbp), %eax
	addl	%eax, %edx
	movzbl	-2(%rbp), %ecx
	movsbl	-1(%rbp), %eax
	cmpl	%eax, %ecx
	sete	%al
	movzbl	%al, %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
