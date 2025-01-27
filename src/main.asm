global start

section .text

bits 32

start:
	mov esp, stack_end	; setup the stack pointer

	; screeen is 80 2 byte characters wide and 25 chars tall
	push (80 * 2) * 12 + (39 * 2)	; push the argument into stack
	call write_42					; call write 42 with offset as argument
	add esp, 4						; remove the argument from stack

	hlt

; load 42 in screen memory, at the offset specified in the first argument
write_42:
	push ebp					; save the C stack frame
	mov ebp, esp

	mov eax, dword [ebp + 8]	; access first argument
	add eax, 0xb8000			; VGA memory starts at 0Xb8000
	mov word [eax], 0x1f34		; ascii 4, white on blue
	mov word [eax + 2], 0x1f32	; ascii 2, white on blue

	mov esp, ebp				; restore the C stack frame
	pop ebp
	ret

; ##############################################################################

; bss section, contains only the stack here
section .bss

stack_begin:
	resb 16384	; 16kb stack
stack_end:
