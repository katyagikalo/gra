    .intel_syntax noprefix
    .global regulafalsi

    .text

    .align 16

regulafalsi:
	push rbx					// fn
    	push rbp					// n
    	sub rsp, 0x50				// 0x0: current a, 0x10: current b, 0x20: fn(a), 0x30: fn(b), 0x40: c
    
    	mov rbx, rdi
    	mov rbp, rsi
    
loop:
	movsd [rsp], xmm0			// a
 
	cmp rbp, 0
    	jle end_n
    
    	movsd [rsp + 0x10], xmm1		// b
    
	call rbx
    
    	movsd [rsp + 0x20], xmm0	// fn(a)
    
    	movsd xmm0, [rsp + 0x10]
    
    	call rbx		
    
    	movsd [rsp + 0x30], xmm0	// f(b)
    
    	subsd xmm0, [rsp + 0x20]	// fn(b) - fn(a)
    	movsd xmm1, xmm0	
    
   	movsd xmm0, [rsp + 0x20]
    	mulsd xmm0, [rsp + 0x10]		// b * fn(a)
    	movsd [rsp + 0x40], xmm0
    
    	movsd xmm0, [rsp + 0x30]
    	mulsd xmm0, [rsp]			// a * fn(b)
    	subsd xmm0, [rsp + 0x40]	// a * fn(b) - b * fn(a)
    
    	divsd xmm0, xmm1			// (a * fn(b) - b * fn(a)) / (fn(b) - fn(a))
    	movsd [rsp + 0x40], xmm0	// c = (a * fn(b) - b * fn(a)) / (fn(b) - fn(a))
    
    	call rbx
    
    	movsd xmm1, xmm0			// fn(c)
    
    	mov rax, 0
    	pxor xmm2, xmm2
    	cvtsi2sd xmm2, rax
    	ucomisd xmm0, xmm2
    	jb neg
    
proof:
	mov rax, 1
    	pxor xmm2, xmm2
    	cvtsi2sd xmm2, rax
    	mov rax, 1000000
    	pxor xmm3, xmm3
    	cvtsi2sd xmm3, rax
    	divsd xmm2, xmm3
    
	ucomisd xmm0, xmm2
    	jb end_0
    
    	movsd xmm0, [rsp + 0x20]
    	mulsd xmm0, xmm1			// fn(a) * fn(c)
    
    	mov rax, 0
    	pxor xmm2, xmm2
    	cvtsi2sd xmm2, rax
    	ucomisd xmm0, xmm2			// if (fn(a) * fn(c) > 0) then sgn(fn(a)) = sgn(fn(c))
    	ja samesign
    
    	movsd xmm1, [rsp + 0x40] 
    	movsd xmm0, [rsp]

stop:
   	dec rbp
    	jmp loop
    
samesign:
	movsd xmm0, [rsp + 0x40] 
    	movsd xmm1, [rsp + 0x10]
	jmp stop
    
neg:
	pxor xmm2, xmm2
	subsd xmm2, xmm0
	movsd xmm0, xmm2
    	jmp proof
    
end_n:
	movsd xmm0, [rsp]
    	jmp end
end_0:
	movsd xmm0, [rsp + 0x40]
end:
	add rsp, 0x50
    	pop rbx
    	pop rbp
	ret
