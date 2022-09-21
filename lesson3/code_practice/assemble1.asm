
assemble1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <to_digit>:
   0:	8b 07                	mov    (%rdi),%eax
   2:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   8:	83 c0 30             	add    $0x30,%eax
   b:	48 98                	cltq   
   d:	c3                   	retq   

000000000000000e <foo>:
   e:	48 83 ec 18          	sub    $0x18,%rsp
  12:	89 7c 24 0c          	mov    %edi,0xc(%rsp)
  16:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
  1b:	e8 00 00 00 00       	callq  20 <foo+0x12>
  20:	0f be f8             	movsbl %al,%edi
  23:	e8 00 00 00 00       	callq  28 <foo+0x1a>
  28:	48 83 c4 18          	add    $0x18,%rsp
  2c:	c3                   	retq   
