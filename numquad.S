    .intel_syntax noprefix
     .global numquad
     .global fn_x2

     .text

     .align 16
numquad:
	cmp rsi, 1
    jle nan
    
    pxor xmm5, xmm5			// sum in xmm5
    pxor xmm6, xmm6			// b in xmm6
    pxor xmm7, xmm7			// a in xmm7
    pxor xmm8, xmm8			// step in xmm8
    
    movapd xmm6, xmm1
    movapd xmm7, xmm0
    
    movapd xmm8, xmm1
    subsd xmm8, xmm0		// b - a
    
    mov rax, rsi			// n in rax
    dec rax					// n - 1 in rax
    cvtsi2sd xmm3, rax		// n - 1 in xmm3
    
    divsd xmm8, xmm3		// (b - a) / (n - 1)
    
    movapd xmm1, xmm8		// b = step
    addsd xmm1, xmm0		// b = step + a
    
loop:    
    push rbx				// f in callee saved rbx
    pxor xmm9, xmm9			// a
    pxor xmm10, xmm10		// b
    pxor xmm11, xmm11		// f(a)
    
    mov rbx, rdi			// f in rbx
    movapd xmm9, xmm0
    movapd xmm10, xmm1
    
    sub rsp, 112
    movq [rsp], xmm5
    movq [rsp + 16], xmm6
    movq [rsp + 32], xmm7
    movq [rsp + 48], xmm8
    movq [rsp + 64], xmm9
    movq [rsp + 80], xmm10
    movq [rsp + 96], xmm11
    
    call rbx
    
    movq xmm11, [rsp + 96]
    
    movq xmm11, xmm0		// f(a) in xmm11
    movq xmm0, xmm10		// b in xmm0
    
    movq [rsp + 96], xmm11
    
	call rbx
    
    movq xmm11, [rsp + 96]
    movq xmm10, [rsp + 80]
    movq xmm9, [rsp + 64]
    movq xmm8, [rsp + 48]
    movq xmm7, [rsp + 32]
    movq xmm6, [rsp + 16]
    movq xmm5, [rsp]
    add rsp, 112
    
    movq xmm1, xmm11
    addsd xmm0, xmm1		// f(a) + f(b)
    
    movq xmm1, xmm10		// b in xmm1
    movq xmm2, xmm9			// a in xmm2
    subsd xmm1, xmm2		// (b - a) in xmm1
    
    mulsd xmm0, xmm1		// (b - a) * (f(a) + f(b))
    
    mov rax, 2
    cvtsi2sd xmm1, rax
    divsd xmm0, xmm1		// (b - a) * (f(a) + f(b)) / 2
    
    movq xmm1, xmm10
    
    pop rbx
    
begin:
    addsd xmm5, xmm0		// sum += xmm0
    
	movapd xmm0, xmm1		// new a
    
	movapd xmm1, xmm8		// b = step
    addsd xmm1, xmm0		// b = step + a
    		
    ucomisd xmm1, xmm6		// if new b > start b then end
    ja end
    
    jmp loop
    
end:
	movapd xmm0, xmm5		// sum in xmm0
    ret

nan:
	pxor xmm8, xmm8
    pxor xmm0, xmm0
	divpd xmm0, xmm8
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
