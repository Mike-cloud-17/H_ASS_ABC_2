format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        enterN db 'Enter size of the array:', 10, 13, '>> ', 0

        endl db 10, 13, 0

        info db "Now we'll change the array.", 10, 13, 0

        enterStart db 'Enter the ', 0

        enterEnd db '-st elemet:', 10, 13, '>> ', 0

        outStart db '[ ', 0

        outEnd db ' ]', 10, 13, 0

        newStr db '', 10, 13, 0

        outMiddle db ', ', 0, 10, 13,0

        lastMessage db 'Process has finished. Rerun the program to repeat.',0

        hheap dd ?

        mas dd ?

        i dd ?

        null dd 0

        digit db '%d', 0

        N dd ?

section '.code' code readable executable

        start:
;-------------------------------first act - creating array--------------------------
                push enterN
                call [printf]
                push N
                push digit
                call [scanf]
;creating heap API object
                invoke HeapCreate,HEAP_NO_SERIALIZE,0,0
                mov [hheap],eax
;booking some memory in heap,

;N*8 - amout of memory we book

;in eax would be address of first reserved element
                invoke HeapAlloc,[hheap],HEAP_NO_SERIALIZE,N*8
;If I write this code

;--> sub eax, 1000

;I would imideately catch exception,

;cause memmory before [mas] isn't allocated

;this fact proves that HeapAlloc works
                mov [mas],eax
;You can not move '3' in array cell

;You need to format 3 to 4-byte format (0000 0003) with 'dword 3'

;Or you can put it in the register, and it will format 3 to 4-byte form automatically
                mov [i], -1
                cinvoke printf,newStr
                jmp loop2

                loop2:

                        add [i], 1

                        cinvoke printf,enterStart
                        cinvoke printf,digit,[i]
                        cinvoke printf,enterEnd
;Here we count current array cell address

;It's mas + i * 4

;but we cannot operate with mas and i, so we use registers
                        mov ecx, [i]
                        imul ecx, dword 4
                        mov eax, [mas]
                        add eax, ecx
;now cell address is in eax
                        cinvoke scanf, digit, eax
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N]
                        jne loop2
                        jmp end2

                end2:
;That's loop for outputting array, it works like previos

;but there is small tape for nice output

                        cinvoke printf,newStr
                        cinvoke printf,outStart
                        mov [i], -1
                        jmp loop3

                loop3:

                        add [i], 1
                        mov ecx, [i]
                        imul ecx, dword 4
                        mov eax, [mas]
                        add eax, ecx
                        cinvoke printf, digit, dword [eax]
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N] ; If (i == n - 1)
                        jne printDot
                        jmp loop3cont

                printDot: ; then printf ', '

                        cinvoke printf,outMiddle

                loop3cont:

                        mov ecx, [i]

                        add ecx, 1

                        cmp ecx, [N]

                        jne loop3

                        jmp end3
                end3:
                        cinvoke printf,outEnd
                        cinvoke printf,newStr
                        cinvoke printf,info
                        mov [i], -1
                        jmp loop4
                loop4:

                        add [i], 1 ;for (int i = 0; i < N; i++)]

                        mov ecx, [i] ;same as i < N

                        imul ecx, dword 4

                        mov eax, [mas]

                        add eax, ecx

                        mov ebx, [eax]

                        cmp ebx,5
                        jg moreThan5

                        cmp ebx, -5

                        jl lessThanNeg5
                        jmp elssse

                        continueLoop4:

                        mov [eax], ebx

                        mov ecx, [i]

                        add ecx, 1

                        cmp ecx, [N]

                        jne loop4

                        jmp end4

                moreThan5:
                        add ebx, 5
                        jmp continueLoop4

                lessThanNeg5:
                        add ebx, -5
                        jmp continueLoop4
                elssse:
                        mov ebx, 0
                        jmp continueLoop4

                end4:
                        cinvoke printf, endl
                        mov [i], -1
                        cinvoke printf,outStart
                        jmp loop5
                loop5:
                        add [i], 1
                        mov ecx, [i]
                        imul ecx, dword 4
                        mov eax, [mas]
                        add eax, ecx
                        cinvoke printf, digit, dword [eax]
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N] ; If (i == n - 1)
                        jne printDot5
                        jmp loop5cont

                printDot5: ; then printf ', '
                        cinvoke printf,outMiddle

                loop5cont:
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N]
                        jne loop5
                        jmp end5
                end5:
                        cinvoke printf,outEnd
                        cinvoke printf,newStr
                        cinvoke printf,lastMessage

                        call [getch]

                        push [null]

                        call [ExitProcess]

section 'idata' import data readable

        library kernel, 'kernel32.dll',\
               msvcrt, 'msvcrt.dll',\
               user32,'USER32.DLL'
               include 'api\user32.inc'
               include 'api\kernel32.inc'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               HeapCreate, 'HeapCreate',\
               HeapAlloc, 'HeapAlloc'
               include 'api\kernel32.inc'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
