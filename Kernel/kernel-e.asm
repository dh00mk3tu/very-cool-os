[bits 32]
[extern main] 
; The above line kind-of says that the entry point is 'main' in our kernel.c file.
; Read more about extern maybe.


call main 
; This line is calling the main function from our kernel.c file. 

jmp $