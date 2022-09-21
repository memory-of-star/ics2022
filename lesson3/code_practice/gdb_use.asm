
a.out:     file format elf64-x86-64


Disassembly of section .init:

00000000000004e8 <_init>:
 4e8:	48 83 ec 08          	sub    $0x8,%rsp
 4ec:	48 8b 05 f5 0a 20 00 	mov    0x200af5(%rip),%rax        # 200fe8 <__gmon_start__>
 4f3:	48 85 c0             	test   %rax,%rax
 4f6:	74 02                	je     4fa <_init+0x12>
 4f8:	ff d0                	callq  *%rax
 4fa:	48 83 c4 08          	add    $0x8,%rsp
 4fe:	c3                   	retq   

Disassembly of section .plt:

0000000000000500 <.plt>:
 500:	ff 35 ba 0a 20 00    	pushq  0x200aba(%rip)        # 200fc0 <_GLOBAL_OFFSET_TABLE_+0x8>
 506:	ff 25 bc 0a 20 00    	jmpq   *0x200abc(%rip)        # 200fc8 <_GLOBAL_OFFSET_TABLE_+0x10>
 50c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000510 <puts@plt>:
 510:	ff 25 ba 0a 20 00    	jmpq   *0x200aba(%rip)        # 200fd0 <puts@GLIBC_2.2.5>
 516:	68 00 00 00 00       	pushq  $0x0
 51b:	e9 e0 ff ff ff       	jmpq   500 <.plt>

Disassembly of section .plt.got:

0000000000000520 <__cxa_finalize@plt>:
 520:	ff 25 d2 0a 20 00    	jmpq   *0x200ad2(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 526:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000000530 <_start>:
 530:	31 ed                	xor    %ebp,%ebp
 532:	49 89 d1             	mov    %rdx,%r9
 535:	5e                   	pop    %rsi
 536:	48 89 e2             	mov    %rsp,%rdx
 539:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 53d:	50                   	push   %rax
 53e:	54                   	push   %rsp
 53f:	4c 8d 05 ba 01 00 00 	lea    0x1ba(%rip),%r8        # 700 <__libc_csu_fini>
 546:	48 8d 0d 43 01 00 00 	lea    0x143(%rip),%rcx        # 690 <__libc_csu_init>
 54d:	48 8d 3d e6 00 00 00 	lea    0xe6(%rip),%rdi        # 63a <main>
 554:	ff 15 86 0a 20 00    	callq  *0x200a86(%rip)        # 200fe0 <__libc_start_main@GLIBC_2.2.5>
 55a:	f4                   	hlt    
 55b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000560 <deregister_tm_clones>:
 560:	48 8d 3d a9 0a 20 00 	lea    0x200aa9(%rip),%rdi        # 201010 <__TMC_END__>
 567:	55                   	push   %rbp
 568:	48 8d 05 a1 0a 20 00 	lea    0x200aa1(%rip),%rax        # 201010 <__TMC_END__>
 56f:	48 39 f8             	cmp    %rdi,%rax
 572:	48 89 e5             	mov    %rsp,%rbp
 575:	74 19                	je     590 <deregister_tm_clones+0x30>
 577:	48 8b 05 5a 0a 20 00 	mov    0x200a5a(%rip),%rax        # 200fd8 <_ITM_deregisterTMCloneTable>
 57e:	48 85 c0             	test   %rax,%rax
 581:	74 0d                	je     590 <deregister_tm_clones+0x30>
 583:	5d                   	pop    %rbp
 584:	ff e0                	jmpq   *%rax
 586:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 58d:	00 00 00 
 590:	5d                   	pop    %rbp
 591:	c3                   	retq   
 592:	0f 1f 40 00          	nopl   0x0(%rax)
 596:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 59d:	00 00 00 

00000000000005a0 <register_tm_clones>:
 5a0:	48 8d 3d 69 0a 20 00 	lea    0x200a69(%rip),%rdi        # 201010 <__TMC_END__>
 5a7:	48 8d 35 62 0a 20 00 	lea    0x200a62(%rip),%rsi        # 201010 <__TMC_END__>
 5ae:	55                   	push   %rbp
 5af:	48 29 fe             	sub    %rdi,%rsi
 5b2:	48 89 e5             	mov    %rsp,%rbp
 5b5:	48 c1 fe 03          	sar    $0x3,%rsi
 5b9:	48 89 f0             	mov    %rsi,%rax
 5bc:	48 c1 e8 3f          	shr    $0x3f,%rax
 5c0:	48 01 c6             	add    %rax,%rsi
 5c3:	48 d1 fe             	sar    %rsi
 5c6:	74 18                	je     5e0 <register_tm_clones+0x40>
 5c8:	48 8b 05 21 0a 20 00 	mov    0x200a21(%rip),%rax        # 200ff0 <_ITM_registerTMCloneTable>
 5cf:	48 85 c0             	test   %rax,%rax
 5d2:	74 0c                	je     5e0 <register_tm_clones+0x40>
 5d4:	5d                   	pop    %rbp
 5d5:	ff e0                	jmpq   *%rax
 5d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 5de:	00 00 
 5e0:	5d                   	pop    %rbp
 5e1:	c3                   	retq   
 5e2:	0f 1f 40 00          	nopl   0x0(%rax)
 5e6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 5ed:	00 00 00 

00000000000005f0 <__do_global_dtors_aux>:
 5f0:	80 3d 19 0a 20 00 00 	cmpb   $0x0,0x200a19(%rip)        # 201010 <__TMC_END__>
 5f7:	75 2f                	jne    628 <__do_global_dtors_aux+0x38>
 5f9:	48 83 3d f7 09 20 00 	cmpq   $0x0,0x2009f7(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 600:	00 
 601:	55                   	push   %rbp
 602:	48 89 e5             	mov    %rsp,%rbp
 605:	74 0c                	je     613 <__do_global_dtors_aux+0x23>
 607:	48 8b 3d fa 09 20 00 	mov    0x2009fa(%rip),%rdi        # 201008 <__dso_handle>
 60e:	e8 0d ff ff ff       	callq  520 <__cxa_finalize@plt>
 613:	e8 48 ff ff ff       	callq  560 <deregister_tm_clones>
 618:	c6 05 f1 09 20 00 01 	movb   $0x1,0x2009f1(%rip)        # 201010 <__TMC_END__>
 61f:	5d                   	pop    %rbp
 620:	c3                   	retq   
 621:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 628:	f3 c3                	repz retq 
 62a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000000630 <frame_dummy>:
 630:	55                   	push   %rbp
 631:	48 89 e5             	mov    %rsp,%rbp
 634:	5d                   	pop    %rbp
 635:	e9 66 ff ff ff       	jmpq   5a0 <register_tm_clones>

000000000000063a <main>:
 63a:	55                   	push   %rbp
 63b:	48 89 e5             	mov    %rsp,%rbp
 63e:	b8 00 00 00 00       	mov    $0x0,%eax
 643:	e8 13 00 00 00       	callq  65b <fun>
 648:	48 8d 3d c5 00 00 00 	lea    0xc5(%rip),%rdi        # 714 <_IO_stdin_used+0x4>
 64f:	e8 bc fe ff ff       	callq  510 <puts@plt>
 654:	b8 00 00 00 00       	mov    $0x0,%eax
 659:	5d                   	pop    %rbp
 65a:	c3                   	retq   

000000000000065b <fun>:
 65b:	55                   	push   %rbp
 65c:	48 89 e5             	mov    %rsp,%rbp
 65f:	48 83 ec 10          	sub    $0x10,%rsp
 663:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
 66a:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
 671:	8b 45 fc             	mov    -0x4(%rbp),%eax
 674:	01 45 f8             	add    %eax,-0x8(%rbp)
 677:	48 8d 3d a3 00 00 00 	lea    0xa3(%rip),%rdi        # 721 <_IO_stdin_used+0x11>
 67e:	e8 8d fe ff ff       	callq  510 <puts@plt>
 683:	90                   	nop
 684:	c9                   	leaveq 
 685:	c3                   	retq   
 686:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 68d:	00 00 00 

0000000000000690 <__libc_csu_init>:
 690:	41 57                	push   %r15
 692:	41 56                	push   %r14
 694:	49 89 d7             	mov    %rdx,%r15
 697:	41 55                	push   %r13
 699:	41 54                	push   %r12
 69b:	4c 8d 25 16 07 20 00 	lea    0x200716(%rip),%r12        # 200db8 <__frame_dummy_init_array_entry>
 6a2:	55                   	push   %rbp
 6a3:	48 8d 2d 16 07 20 00 	lea    0x200716(%rip),%rbp        # 200dc0 <__init_array_end>
 6aa:	53                   	push   %rbx
 6ab:	41 89 fd             	mov    %edi,%r13d
 6ae:	49 89 f6             	mov    %rsi,%r14
 6b1:	4c 29 e5             	sub    %r12,%rbp
 6b4:	48 83 ec 08          	sub    $0x8,%rsp
 6b8:	48 c1 fd 03          	sar    $0x3,%rbp
 6bc:	e8 27 fe ff ff       	callq  4e8 <_init>
 6c1:	48 85 ed             	test   %rbp,%rbp
 6c4:	74 20                	je     6e6 <__libc_csu_init+0x56>
 6c6:	31 db                	xor    %ebx,%ebx
 6c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 6cf:	00 
 6d0:	4c 89 fa             	mov    %r15,%rdx
 6d3:	4c 89 f6             	mov    %r14,%rsi
 6d6:	44 89 ef             	mov    %r13d,%edi
 6d9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
 6dd:	48 83 c3 01          	add    $0x1,%rbx
 6e1:	48 39 dd             	cmp    %rbx,%rbp
 6e4:	75 ea                	jne    6d0 <__libc_csu_init+0x40>
 6e6:	48 83 c4 08          	add    $0x8,%rsp
 6ea:	5b                   	pop    %rbx
 6eb:	5d                   	pop    %rbp
 6ec:	41 5c                	pop    %r12
 6ee:	41 5d                	pop    %r13
 6f0:	41 5e                	pop    %r14
 6f2:	41 5f                	pop    %r15
 6f4:	c3                   	retq   
 6f5:	90                   	nop
 6f6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 6fd:	00 00 00 

0000000000000700 <__libc_csu_fini>:
 700:	f3 c3                	repz retq 

Disassembly of section .fini:

0000000000000704 <_fini>:
 704:	48 83 ec 08          	sub    $0x8,%rsp
 708:	48 83 c4 08          	add    $0x8,%rsp
 70c:	c3                   	retq   
