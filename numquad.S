    .intel_syntax noprefix
     .global numquad
     .global fn_x2

     .text

     .align 16
numquad:
	cmp rsi, 1
    jle nan
    
    push rbp				// step counter in callee saved rbp
    push r15				// b in callee saved r15
    
    movq r15, xmm1
    movapd xmm4, xmm1
    subsd xmm4, xmm0		// b - a
    mov rbp, rsi			// n in rbp
    dec rbp					// n - 1 in rbp
    cvtsi2sd xmm3, rbp		// n - 1 in xmm3
    divsd xmm4, xmm3		// (b - a) / (n - 1)
    movq rbp, xmm4
    
    movq xmm4, rbp
    addsd xmm4, xmm0
    movapd xmm1, xmm4
    
    pxor xmm5, xmm5			// sum in xmm5
    
loop:    
    push rbx				// f in callee saved rbx
    push r12				// a in callee saved r12
    push r13				// b in callee saved r13
    
    mov rbx, rdi			// f in rbx
    movq r12, xmm0			// a in r12
    movq r13, xmm1			// b in r13
    
    sub rsp, 16
    movq [rsp], xmm5
    
	call rdi
   
    movq xmm5, [rsp]
    add rsp, 16
    
    mov rdi, rbx
    
    push r14				// f(a) in callee saved r14
    movq r14, xmm0			// f(a) in r14
    movq xmm0, r13			// b in xmm0
    
    sub rsp, 16
    movq [rsp], xmm5
    
    sub rsp, 8
	call rdi
    add rsp, 8
    
    movq xmm5, [rsp]
    add rsp, 16
    
    mov rdi, rbx
    
    movq xmm1, r14
    pop r14
    addsd xmm0, xmm1		// f(a) + f(b)
    
    movq xmm1, r13			// b in xmm3
    movq xmm2, r12			// a in xmm2
    subsd xmm1, xmm2		// (b-a) in xmm1
    
    mulsd xmm0, xmm1		// (b-a) * (f(a) + f(b))
    
    mov rax, 2
    cvtsi2sd xmm1, rax
    divsd xmm0, xmm1		// (b-a) * (f(a) + f(b)) / 2
    
    movq xmm1, r13
    
    pop r13
    pop r12
    pop rbx
    
begin:
    addsd xmm5, xmm0		// sum += xmm0
    
	movapd xmm0, xmm1		// new a
    
	movq xmm4, rbp
    addsd xmm4, xmm0		// new a + step
    movapd xmm1, xmm4		// new b
    
    movq xmm4, r15			// if new b > start b then end
    ucomisd xmm1, xmm4
    ja end
    
    jmp loop
    
end:
	movapd xmm0, xmm5		// sum in xmm0
    pop r15
    pop rbp
    ret

nan:
	pxor xmm7, xmm7
    pxor xmm0, xmm0
	divpd xmm0, xmm7
    ret



     .align 16
 fn_x2: // double fn_x2(double)
     // This function makes full use of its rights granted by the ABI.
     // No need to reduce the stack pointer, as the ABI defines
     // a freely usable "red zone" of 128 Bytes below rsp.

     // Check whether stack is suitably aligned.
     movaps [rsp - 0x18], xmm0
     pxor xmm0, xmm0; pxor xmm1, xmm1; pxor xmm2, xmm2; pxor xmm3, xmm3
     pxor xmm4, xmm4; pxor xmm5, xmm5; pxor xmm6, xmm6; pxor xmm7, xmm7
     pxor xmm8, xmm8; pxor xmm9, xmm9; pxor xmm10, xmm10; pxor xmm11, xmm11
     pxor xmm12, xmm12; pxor xmm13, xmm13; pxor xmm14, xmm14; pxor xmm15, xmm15
     xor eax, eax; xor ecx, ecx; xor edx, edx; xor esi, esi; xor edi, edi
     xor r8, r8; xor r9, r9; xor r10, r10; xor r11, r11

     movsd xmm0, [rsp - 0x18]
     mulsd xmm0, xmm0
     ret
