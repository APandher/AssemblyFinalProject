%include "asm_io.inc"

extern rconf

SECTION .data

incorrectargc: db "This program expects one command line argument",10,0

incorrectargv: db "Must enter a number greater than or equal to 2 and less than or equal to 9",10,0

peg: dd  0,0,0,0,0,0,0,0,0

arg1:      db "          o|o          ",10,0
arg2:      db "         oo|oo         ",10,0
arg3:      db "        ooo|ooo        ",10,0
arg4:      db "       oooo|oooo       ",10,0
arg5:      db "      ooooo|ooooo      ",10,0
arg6:      db "     oooooo|oooooo     ",10,0
arg7:      db "    ooooooo|ooooooo    ",10,0
arg8:      db "   oooooooo|oooooooo   ",10,0
arg9:      db "  ooooooooo|ooooooooo  ",10,0
seperator: db "XXXXXXXXXXXXXXXXXXXXXXX",10,0

numdisk: dd 0
inital:    db "  Initial configuration           ",10,0
final:     db "  Final configuration             ",10,0

SECTION .bss

SECTION .text
	global asm_main
	
showp:
	enter 0,0
	pusha
	
	call read_char

	mov ebx, [ebp+8]
	add ebx, 32
 	mov eax, [ebx]	
	mov edx, 0
	mov ecx, dword 9

LOOP:
	cmp edx, ecx
	je endprint
	cmp eax, dword 0
	je corrector

	cmp eax, dword 0
	je corrector
	cmp eax, dword 1
	je L1
	cmp eax, dword 2
	je L2
	cmp eax, dword 3
	je L3
	cmp eax, dword 4
	je L4
	cmp eax, dword 5
	je L5
	cmp eax, dword 6
	je L6
	cmp eax, dword 7
	je L7
	cmp eax, dword 8
	je L8
	cmp eax, dword 9 
	je L9
	jmp endprint


L1: 
mov eax, arg1
call print_string
jmp corrector

L2:
mov eax, arg2
call print_string
jmp corrector

L3: 
mov eax, arg3
call print_string
jmp corrector

L4:
mov eax, arg4
call print_string
jmp corrector

L5:
mov eax, arg5
call print_string
jmp corrector
	
L6:
mov eax, arg6
call print_string
jmp corrector
	 
L7:
mov eax, arg7
call print_string
jmp corrector 

L8:
mov eax, arg8
call print_string
jmp corrector

L9:
mov eax, arg9 
call print_string
jmp corrector

corrector:
sub ebx, 4
mov eax, dword [ebx]
inc edx
jmp LOOP	

endprint:
	mov eax, seperator
	call print_string
	call print_nl
	popa
	leave
	ret




sorthem:
	enter 0,0
	pusha

	mov ecx, dword [ebp+8]  ;peg array
	mov edx, dword [ebp+12]  ;num pegs


	cmp edx, 1                ;base case
	je sorthem_end


	dec edx               ;set up recursion
	push edx
	add ecx, 4
	push ecx
	
	inc edx
	sub ecx, 4

	call sorthem
	add esp, 8


	mov ebx, 0 ;counter



sortingLoop:

	dec edx
	cmp ebx, edx
	je printVal
	inc edx

	mov eax, dword [ecx+ebx*4]   ;compare A[i] with A[i+1]
	cmp eax, dword [ecx+ebx*4+4]
	ja printVal
	jmp Swap

printVal:
	push dword [numdisk]
	push peg
	call showp
	add esp, 8
	jmp sorthem_end
	

	
Swap:

	mov esi, dword [ecx+ebx*4]        ;perform the swap
	mov edi, dword [ecx+ebx*4+4]

	mov [ecx+ebx*4], edi
	mov [ecx+ebx*4+4], esi
	
	inc ebx
	jmp sortingLoop



sorthem_end:
	popa 
	leave 
	ret	



    
asm_main:
	enter 0,0
	pusha 
	
	;checking to see if the number of command line arguments is correct

	mov eax, [dword ebp+8]
	cmp eax, dword 2
	jne argcerror


	;checking to see if the command line argument is ge 2 and le 9 

	mov ebx, dword [ebp+12]
	mov eax, [ebx+4]

	mov bl, byte [eax+1]
	cmp bl, byte 0
	jne argverror


	mov bl, byte [eax]
	mov eax, 0
	mov al, bl
	sub al,'0'
	cmp eax, dword 2
	jl argverror
	cmp eax, dword 9
	jg argverror
	


	;set up the parameters for calling rconf  
	mov ecx, peg
	mov [numdisk], eax
	push eax
	push peg
	call rconf
	add esp, 8

	mov eax, inital
	call print_string

	push dword [numdisk] 
	push peg 
	call showp
	add esp, 8

	push dword [numdisk]
	push peg
	call sorthem 
	add esp, 8
	
	call print_nl
	mov eax, final	
	call print_string

	push dword [numdisk]
	push peg 
	call showp
	add esp,8
	
	jmp end

	


argcerror:

	mov eax, incorrectargc
	call print_string
	jmp end

argverror: 
	
	mov eax, incorrectargv
	call print_string
	jmp end


end:
	popa
	mov eax, 0
	leave
	ret 
	
	
