    .intel_syntax noprefix
    .global numquad
    .global fn_x2

    .text

    .align 16
numquad: // double numquad(double(* f)(double), double a, double b, size_t n)
    // TODO: implement this function
    pxor xmm0, xmm0
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
