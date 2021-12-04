    .intel_syntax noprefix
    .global regulafalsi

    .text

    .align 16

regulafalsi:
	push rbx					// fn
    push rbp					// n
    sub rsp, 0x28				// 0x0: current a, 0x8: current b, 0x10: fn(a), 0x18: fn(b), 0x20: c
    
    mov rbx, rdi				// fn in rbx sichern
    mov rbp, rsi				// n in rbp sichern
    
loop:
	movsd [rsp], xmm0			// a sichern
 
	cmp rbp, 0					// falls wir keine Schritte mehr haben
    jle end_n
    
    movsd [rsp + 0x8], xmm1		// b sichern
    
	call rbx					// fn(a)
    
   	movsd [rsp + 0x10], xmm0	// fn(a) sichern
    
   	movsd xmm0, [rsp + 0x8]	
    
   	call rbx					// fn(b)
    
   	movsd [rsp + 0x18], xmm0	// f(b) sichern
    
   	subsd xmm0, [rsp + 0x10]	// fn(b) - fn(a)
   	movsd xmm1, xmm0	
    
   	movsd xmm0, [rsp + 0x10]
   	mulsd xmm0, [rsp + 0x8]		// b * fn(a)
   	movsd [rsp + 0x20], xmm0
    
   	movsd xmm0, [rsp + 0x18]
   	mulsd xmm0, [rsp]			// a * fn(b)
   	subsd xmm0, [rsp + 0x20]	// a * fn(b) - b * fn(a)
    
   	divsd xmm0, xmm1			// (a * fn(b) - b * fn(a)) / (fn(b) - fn(a))
   	movsd [rsp + 0x20], xmm0	// c = (a * fn(b) - b * fn(a)) / (fn(b) - fn(a))
    
   	call rbx					// fn(c)
    
   	movsd xmm1, xmm0			// fn(c) sichern
    
   	pxor xmm2, xmm2
   	ucomisd xmm0, xmm2
   	jb neg
    
proof:
	mov rax, 1
   	pxor xmm2, xmm2
   	cvtsi2sd xmm2, rax
   	mov rax, 1000000
   	pxor xmm3, xmm3
   	cvtsi2sd xmm3, rax
   	divsd xmm2, xmm3			// 1/1000000
    
	ucomisd xmm0, xmm2
   	jb end_0
    
   	movsd xmm0, [rsp + 0x10]
   	mulsd xmm0, xmm1			// fn(a) * fn(c)
   
   	pxor xmm2, xmm2
   	ucomisd xmm0, xmm2			// if (fn(a) * fn(c) > 0) then sgn(fn(a)) = sgn(fn(c))
   	ja samesign
    
   	movsd xmm1, [rsp + 0x20] 
   	movsd xmm0, [rsp]

loop_end:
   	dec rbp
   	jmp loop
    
samesign:
	movsd xmm0, [rsp + 0x20] 
   	movsd xmm1, [rsp + 0x8]
	jmp loop_end
    
neg:
	pxor xmm2, xmm2
	subsd xmm2, xmm0			// 0 - fn(c)
	movsd xmm0, xmm2
    jmp proof
    
end_n:
	movsd xmm0, [rsp]
   	jmp end
end_0:
	movsd xmm0, [rsp + 0x20]
end:
	add rsp, 0x28
    pop rbx
   	pop rbp
	ret
