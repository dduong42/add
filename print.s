section .text
global print_char
global print_integer

; void print_char(int c)
print_char:
	; [rsp] = rdi
	push rdi

	; write(1, &c, 1)
	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	syscall

	pop rdi
	ret

; void print_integer(int n)
print_integer:
	; Check if n < 0
	test rdi, rdi
	jge .non_negative_integer

	; Save rdi
	push rdi

	; putchar('-')
	mov rdi, '-'
	call print_char

	; Restore rdi
	pop rdi

	; rdi = -rdi
	neg rdi

.non_negative_integer:
	; Clear rdx
	xor rdx, rdx

	mov rax, rdi
	; n == rax * 10 + rdx
	idiv qword [ten]

	; Save rdx
	push rdx
	
	; If rax == 0, print the remainder
	test rax, rax
	je .print_remainder

	; Otherwise, recurse
	; print_integer(n / 10)
	mov rdi, rax
	call .non_negative_integer

.print_remainder:
	; Right now the top of the stack is rdx, the remainder
	; rdi = rdx	
	pop rdi
	; rdi += '0'
	add rdi, '0'

	; print_char(rdx + '0')
	call print_char
	ret

section .data
	ten dq 10
