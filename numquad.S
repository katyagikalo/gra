numquad:
	cmp rsi, 1
    jle nan
    
    push rbp				// step counter in callee saved rbp
    push r15				// b in callee saved r15
    push r14				// sum in r14
    
    xor r14, r14
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
    
loop:    
    push rbx				// f in callee saved rbx
    push r12				// a in callee saved r12
    push r13				// b in callee saved r13
    
    mov rbx, rdi			// f in rbx
    movq r12, xmm0			// a in r12
    movq r13, xmm1			// b in r13
    
    sub rsp, 8
	call rdi
    add rsp, 8
    
    mov rdi, rbx
    
    push r14				// f(a) in callee saved r14
    movq r14, xmm0			// f(a) in r14
    movq xmm0, r13			// b in xmm0
    
    //sub rsp, 8
	call rdi
    //add rsp, 8
    
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
	movq xmm5, r14
    addsd xmm5, xmm0		// sum += xmm0
    movq r14, xmm5
    
	movapd xmm0, xmm1		// new a
    
	movq xmm4, rbp
    addsd xmm4, xmm0
    movapd xmm1, xmm4		// new b
    
    movq rax, xmm1			// if new b > start b then end
    cmp rax, r15
    jg end
    
    
    jmp loop
    
end:
	movq xmm0, r14
    pop r14
    pop r15
    pop rbp
    ret

nan:
	pxor xmm7, xmm7
    pxor xmm0, xmm0
	divpd xmm0, xmm7
    ret
