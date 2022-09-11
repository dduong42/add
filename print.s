%define write 1
%define max_string_size 19
%define stdout 1

section .text
global print_char
global print_integer

; void print_char(char c)
print_char:
	; [rsp] = rdi
	push rdi

	; write(1, &c, 1)
	mov rax, write
	mov rdi, stdout
	mov rsi, rsp
	mov rdx, 1
	syscall

	pop rdi
	ret

; void print_integer(long long n)
print_integer:
	push rbp
	mov rbp, rsp

	; Use rsi to point to the end of the string
	lea rsi, [rbp - 1]

	; Start to divide
	mov rax, rdi

	; Check if n < 0
	test rax, rax
	jge .divide
	neg rax

.divide:
	xor rdx, rdx
	idiv qword [ten]
	add dl, '0'
	mov [rsi], dl
	dec rsi
	test rax, rax
	jne .divide

	; Check if n < 0
	test rdi, rdi
	jge .write

	mov [rsi], byte '-'

.write:
	mov rax, write
	mov rdi, stdout
	mov rdx, rbp
	sub rdx, rsi
	syscall

	pop rbp
	ret

section .data
	ten dq 10
