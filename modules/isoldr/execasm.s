! DreamShell ##version##
!
!   execasm.s
!   Copyright (C) 2002 Dan Potter
!   Copyright (C) 2013-2018 SWAT
!
! This is the assembler code on which exec.c bases its trampoline.
!

	.globl		__isoldr_exec_template
	.globl		__isoldr_exec_template_values
	.globl		__isoldr_exec_template_end

	.text
	.align		2
__isoldr_exec_template:
	mov.l		.ccraddr,r0	! Disable/invalidate cache
	mov.l		.ccrdata,r1
	mov.l		r1,@r0

	mov.l		.srcval,r0	! Get src/dst pointers
	mov.l		.dstval,r1
	mov.l		.count,r2	! Get uint32 count

.loop:
	mov.l		@r0+,r3	! Read a source word
	mov.l		r3,@r1		! Write a dest word
	add			#-1,r2		! Dec count
	cmp/pl		r2
	bt.s		.loop
	add			#4,r1		! Incr to next dest word

	mov.l		.oldstack,r15	! Put back the old stack pointer and PR
	lds.l		@r15+,pr

	mov.l		.dstval,r1	! Get the dst pointer again
	mov.l       .prmsize,r2
	add         r2,r1
	mov         #0,r2
	jmp			@r1
	nop

	.align		2
__isoldr_exec_template_values:
.srcval:
	.long		0
.dstval:
	.long		0
.count:
	.long		0
.oldstack:
	.long		0
.prmsize:
	.long		0
.ccraddr:
	.long		0xff00001c
.ccrdata:
	.long		0x00000808
__isoldr_exec_template_end:
