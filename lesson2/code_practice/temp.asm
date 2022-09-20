
a.out:     file format elf64-x86-64


Disassembly of section .init:

0000000000000548 <_init>:
 548:	48 83 ec 08          	sub    $0x8,%rsp
 54c:	48 8b 05 95 0a 20 00 	mov    0x200a95(%rip),%rax        # 200fe8 <__gmon_start__>
 553:	48 85 c0             	test   %rax,%rax
 556:	74 02                	je     55a <_init+0x12>
 558:	ff d0                	callq  *%rax
 55a:	48 83 c4 08          	add    $0x8,%rsp
 55e:	c3                   	retq   

Disassembly of section .plt:

0000000000000560 <.plt>:
 560:	ff 35 52 0a 20 00    	pushq  0x200a52(%rip)        # 200fb8 <_GLOBAL_OFFSET_TABLE_+0x8>
 566:	ff 25 54 0a 20 00    	jmpq   *0x200a54(%rip)        # 200fc0 <_GLOBAL_OFFSET_TABLE_+0x10>
 56c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000570 <__stack_chk_fail@plt>:
 570:	ff 25 52 0a 20 00    	jmpq   *0x200a52(%rip)        # 200fc8 <__stack_chk_fail@GLIBC_2.4>
 576:	68 00 00 00 00       	pushq  $0x0
 57b:	e9 e0 ff ff ff       	jmpq   560 <.plt>

0000000000000580 <printf@plt>:
 580:	ff 25 4a 0a 20 00    	jmpq   *0x200a4a(%rip)        # 200fd0 <printf@GLIBC_2.2.5>
 586:	68 01 00 00 00       	pushq  $0x1
 58b:	e9 d0 ff ff ff       	jmpq   560 <.plt>

Disassembly of section .plt.got:

0000000000000590 <__cxa_finalize@plt>:
 590:	ff 25 62 0a 20 00    	jmpq   *0x200a62(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 596:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

00000000000005a0 <_start>:
 5a0:	31 ed                	xor    %ebp,%ebp
 5a2:	49 89 d1             	mov    %rdx,%r9
 5a5:	5e                   	pop    %rsi
 5a6:	48 89 e2             	mov    %rsp,%rdx
 5a9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 5ad:	50                   	push   %rax
 5ae:	54                   	push   %rsp
 5af:	4c 8d 05 fa 01 00 00 	lea    0x1fa(%rip),%r8        # 7b0 <__libc_csu_fini>
 5b6:	48 8d 0d 83 01 00 00 	lea    0x183(%rip),%rcx        # 740 <__libc_csu_init>
 5bd:	48 8d 3d e6 00 00 00 	lea    0xe6(%rip),%rdi        # 6aa <main>
 5c4:	ff 15 16 0a 20 00    	callq  *0x200a16(%rip)        # 200fe0 <__libc_start_main@GLIBC_2.2.5>
 5ca:	f4                   	hlt    
 5cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000005d0 <deregister_tm_clones>:
 5d0:	48 8d 3d 39 0a 20 00 	lea    0x200a39(%rip),%rdi        # 201010 <__TMC_END__>
 5d7:	55                   	push   %rbp
 5d8:	48 8d 05 31 0a 20 00 	lea    0x200a31(%rip),%rax        # 201010 <__TMC_END__>
 5df:	48 39 f8             	cmp    %rdi,%rax
 5e2:	48 89 e5             	mov    %rsp,%rbp
 5e5:	74 19                	je     600 <deregister_tm_clones+0x30>
 5e7:	48 8b 05 ea 09 20 00 	mov    0x2009ea(%rip),%rax        # 200fd8 <_ITM_deregisterTMCloneTable>
 5ee:	48 85 c0             	test   %rax,%rax
 5f1:	74 0d                	je     600 <deregister_tm_clones+0x30>
 5f3:	5d                   	pop    %rbp
 5f4:	ff e0                	jmpq   *%rax
 5f6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 5fd:	00 00 00 
 600:	5d                   	pop    %rbp
 601:	c3                   	retq   
 602:	0f 1f 40 00          	nopl   0x0(%rax)
 606:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 60d:	00 00 00 

0000000000000610 <register_tm_clones>:
 610:	48 8d 3d f9 09 20 00 	lea    0x2009f9(%rip),%rdi        # 201010 <__TMC_END__>
 617:	48 8d 35 f2 09 20 00 	lea    0x2009f2(%rip),%rsi        # 201010 <__TMC_END__>
 61e:	55                   	push   %rbp
 61f:	48 29 fe             	sub    %rdi,%rsi
 622:	48 89 e5             	mov    %rsp,%rbp
 625:	48 c1 fe 03          	sar    $0x3,%rsi
 629:	48 89 f0             	mov    %rsi,%rax
 62c:	48 c1 e8 3f          	shr    $0x3f,%rax
 630:	48 01 c6             	add    %rax,%rsi
 633:	48 d1 fe             	sar    %rsi
 636:	74 18                	je     650 <register_tm_clones+0x40>
 638:	48 8b 05 b1 09 20 00 	mov    0x2009b1(%rip),%rax        # 200ff0 <_ITM_registerTMCloneTable>
 63f:	48 85 c0             	test   %rax,%rax
 642:	74 0c                	je     650 <register_tm_clones+0x40>
 644:	5d                   	pop    %rbp
 645:	ff e0                	jmpq   *%rax
 647:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
 64e:	00 00 
 650:	5d                   	pop    %rbp
 651:	c3                   	retq   
 652:	0f 1f 40 00          	nopl   0x0(%rax)
 656:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 65d:	00 00 00 

0000000000000660 <__do_global_dtors_aux>:
 660:	80 3d a9 09 20 00 00 	cmpb   $0x0,0x2009a9(%rip)        # 201010 <__TMC_END__>
 667:	75 2f                	jne    698 <__do_global_dtors_aux+0x38>
 669:	48 83 3d 87 09 20 00 	cmpq   $0x0,0x200987(%rip)        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 670:	00 
 671:	55                   	push   %rbp
 672:	48 89 e5             	mov    %rsp,%rbp
 675:	74 0c                	je     683 <__do_global_dtors_aux+0x23>
 677:	48 8b 3d 8a 09 20 00 	mov    0x20098a(%rip),%rdi        # 201008 <__dso_handle>
 67e:	e8 0d ff ff ff       	callq  590 <__cxa_finalize@plt>
 683:	e8 48 ff ff ff       	callq  5d0 <deregister_tm_clones>
 688:	c6 05 81 09 20 00 01 	movb   $0x1,0x200981(%rip)        # 201010 <__TMC_END__>
 68f:	5d                   	pop    %rbp
 690:	c3                   	retq   
 691:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
 698:	f3 c3                	repz retq 
 69a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000000006a0 <frame_dummy>:
 6a0:	55                   	push   %rbp
 6a1:	48 89 e5             	mov    %rsp,%rbp
 6a4:	5d                   	pop    %rbp
 6a5:	e9 66 ff ff ff       	jmpq   610 <register_tm_clones>

00000000000006aa <main>:
 6aa:	55                   	push   %rbp
 6ab:	48 89 e5             	mov    %rsp,%rbp
 6ae:	48 83 ec 30          	sub    $0x30,%rsp
 6b2:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
 6b9:	00 00 
 6bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
 6bf:	31 c0                	xor    %eax,%eax
 6c1:	c7 45 e0 22 22 11 11 	movl   $0x11112222,-0x20(%rbp)
 6c8:	c7 45 e4 66 66 33 33 	movl   $0x33336666,-0x1c(%rbp)
 6cf:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
 6d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
 6d7:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
 6db:	48 83 c0 02          	add    $0x2,%rax
 6df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
 6e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
 6e7:	0f b7 00             	movzwl (%rax),%eax
 6ea:	66 89 45 dc          	mov    %ax,-0x24(%rbp)
 6ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
 6f2:	0f b7 00             	movzwl (%rax),%eax
 6f5:	66 89 45 de          	mov    %ax,-0x22(%rbp)
 6f9:	0f b7 55 dc          	movzwl -0x24(%rbp),%edx
 6fd:	0f b7 45 de          	movzwl -0x22(%rbp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	89 c6                	mov    %eax,%esi
 705:	48 8d 3d b8 00 00 00 	lea    0xb8(%rip),%rdi        # 7c4 <_IO_stdin_used+0x4>
 70c:	b8 00 00 00 00       	mov    $0x0,%eax
 711:	e8 6a fe ff ff       	callq  580 <printf@plt>
 716:	b8 00 00 00 00       	mov    $0x0,%eax
 71b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
 71f:	64 48 33 0c 25 28 00 	xor    %fs:0x28,%rcx
 726:	00 00 
 728:	74 05                	je     72f <main+0x85>
 72a:	e8 41 fe ff ff       	callq  570 <__stack_chk_fail@plt>
 72f:	c9                   	leaveq 
 730:	c3                   	retq   
 731:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 738:	00 00 00 
 73b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000740 <__libc_csu_init>:
 740:	41 57                	push   %r15
 742:	41 56                	push   %r14
 744:	49 89 d7             	mov    %rdx,%r15
 747:	41 55                	push   %r13
 749:	41 54                	push   %r12
 74b:	4c 8d 25 5e 06 20 00 	lea    0x20065e(%rip),%r12        # 200db0 <__frame_dummy_init_array_entry>
 752:	55                   	push   %rbp
 753:	48 8d 2d 5e 06 20 00 	lea    0x20065e(%rip),%rbp        # 200db8 <__init_array_end>
 75a:	53                   	push   %rbx
 75b:	41 89 fd             	mov    %edi,%r13d
 75e:	49 89 f6             	mov    %rsi,%r14
 761:	4c 29 e5             	sub    %r12,%rbp
 764:	48 83 ec 08          	sub    $0x8,%rsp
 768:	48 c1 fd 03          	sar    $0x3,%rbp
 76c:	e8 d7 fd ff ff       	callq  548 <_init>
 771:	48 85 ed             	test   %rbp,%rbp
 774:	74 20                	je     796 <__libc_csu_init+0x56>
 776:	31 db                	xor    %ebx,%ebx
 778:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 77f:	00 
 780:	4c 89 fa             	mov    %r15,%rdx
 783:	4c 89 f6             	mov    %r14,%rsi
 786:	44 89 ef             	mov    %r13d,%edi
 789:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
 78d:	48 83 c3 01          	add    $0x1,%rbx
 791:	48 39 dd             	cmp    %rbx,%rbp
 794:	75 ea                	jne    780 <__libc_csu_init+0x40>
 796:	48 83 c4 08          	add    $0x8,%rsp
 79a:	5b                   	pop    %rbx
 79b:	5d                   	pop    %rbp
 79c:	41 5c                	pop    %r12
 79e:	41 5d                	pop    %r13
 7a0:	41 5e                	pop    %r14
 7a2:	41 5f                	pop    %r15
 7a4:	c3                   	retq   
 7a5:	90                   	nop
 7a6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 7ad:	00 00 00 

00000000000007b0 <__libc_csu_fini>:
 7b0:	f3 c3                	repz retq 

Disassembly of section .fini:

00000000000007b4 <_fini>:
 7b4:	48 83 ec 08          	sub    $0x8,%rsp
 7b8:	48 83 c4 08          	add    $0x8,%rsp
 7bc:	c3                   	retq   
