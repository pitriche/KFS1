global start

section .text

bits 32

start:
	mov esp, stack_end	; setup the stack pointer

	call clear_screen				; write spaces to all of the screen buffer

	; screeen is 80 2 byte characters wide and 25 chars tall, write 42 in the middle
	push (80 * 2) * 12 + (39 * 2)	; push the argument into stack
	call write_42					; call write 42 with offset as argument
	add esp, 4						; remove the argument from stack

	hlt

clear_screen:
	push ebp					; save the C stack frame
	mov ebp, esp

	mov dl, 0x20
	mov dh, 0x1f
	mov ecx, 0
	.loop:
		mov eax, ecx
		shl eax, 1		; counter * 2
		add eax, 0xb8000; VGA array address

		mov word [eax], dx

		inc ecx
		cmp ecx, 80 * 25
		jne .loop

	mov esp, ebp				; restore the C stack frame
	pop ebp
	ret

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
