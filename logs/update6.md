
### Update 6: 22/04/2021

# C The Kernel 

The objective of this update is pretty clear and straight forward. We will attempt to write the same low level code, that we did in Assembly(using an Assembler) but in C.

This is the prime reason why we built out Cross-Compiler.

Let us try to compile a simple C program with our Cross-Compiler.

```c
int my_function() {
    return 0xbaba;
}
```

We will attempt to compile the above code with our cross-compiler. We compile it using the following command.

```
i686-elf-gcc -ffreestanding -c function.c -o function.o
```

---

I took a day's rest because my health was dwindling a little bit. No, not covid but the casual state of headache I have now.

None the less, as soon as I picked up back on the project to proceed further, I encountered another error. 

I am not able to generate binary files using the cross-compiler I built.

So I went back and repeated the steps I did in Update 5 and now we're good to go.

It took me another 40 minutes to do  everything again. 

## Linker

As I pretty much expected, we would have to use a linker at some point to generate a binary file for whatever code we write and here we are now.

I will not talk about linkers but I will rather describe why we are doing - what we'll do at this step.

In order to produce a binary file we've the following command with the specified flags.

```
i686-elf-ld -o function.bin -Ttext 0x0 --oformat binary function.o
```

Here the ```-ld``` flag describes that we want to use the Linker instead of the compiler.

This step is important because we need to understand how High Level Languages call funtion labels.

We place set the memory offset to ```0x0``` and we'll generate the machine code without any labels. 

Now, if we use ```xxd``` to analyse the files that we have generated, the ```.o``` files generate a lot of debug information while the ```.bin``` files are just machine code.

This is the binary file that we've generated 

```
00000000: 5589 e5b8 baba 0000 5dc3                 U.......].
```

And this is the ```.o``` that we generated of the above code;

```
00000000: 7f45 4c46 0101 0100 0000 0000 0000 0000  .ELF............
00000010: 0100 0300 0100 0000 0000 0000 0000 0000  ................
00000020: cc00 0000 0000 0000 3400 0000 0000 2800  ........4.....(.
00000030: 0800 0700 5589 e5b8 baba 0000 5dc3 0047  ....U.......]..G
00000040: 4343 3a20 2847 4e55 2920 3130 2e33 2e30  CC: (GNU) 10.3.0
00000050: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000060: 0000 0000 0100 0000 0000 0000 0000 0000  ................
00000070: 0400 f1ff 0c00 0000 0000 0000 0a00 0000  ................
00000080: 1200 0100 0066 756e 6374 696f 6e2e 6300  .....function.c.
00000090: 6675 6e63 0000 2e73 796d 7461 6200 2e73  func...symtab..s
000000a0: 7472 7461 6200 2e73 6873 7472 7461 6200  trtab..shstrtab.
000000b0: 2e74 6578 7400 2e64 6174 6100 2e62 7373  .text..data..bss
000000c0: 002e 636f 6d6d 656e 7400 0000 0000 0000  ..comment.......
000000d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000f0: 0000 0000 1b00 0000 0100 0000 0600 0000  ................
00000100: 0000 0000 3400 0000 0a00 0000 0000 0000  ....4...........
00000110: 0000 0000 0100 0000 0000 0000 2100 0000  ............!...
00000120: 0100 0000 0300 0000 0000 0000 3e00 0000  ............>...
00000130: 0000 0000 0000 0000 0000 0000 0100 0000  ................
00000140: 0000 0000 2700 0000 0800 0000 0300 0000  ....'...........
00000150: 0000 0000 3e00 0000 0000 0000 0000 0000  ....>...........
00000160: 0000 0000 0100 0000 0000 0000 2c00 0000  ............,...
00000170: 0100 0000 3000 0000 0000 0000 3e00 0000  ....0.......>...
00000180: 1300 0000 0000 0000 0000 0000 0100 0000  ................
00000190: 0100 0000 0100 0000 0200 0000 0000 0000  ................
000001a0: 0000 0000 5400 0000 3000 0000 0600 0000  ....T...0.......
000001b0: 0200 0000 0400 0000 1000 0000 0900 0000  ................
000001c0: 0300 0000 0000 0000 0000 0000 8400 0000  ................
000001d0: 1100 0000 0000 0000 0000 0000 0100 0000  ................
000001e0: 0000 0000 1100 0000 0300 0000 0000 0000  ................
000001f0: 0000 0000 9500 0000 3500 0000 0000 0000  ........5.......
00000200: 0000 0000 0100 0000 0000 0000            ............
```

Now this is something we can wrap our heads around. 

Just kidding. I got a seizure trying to decode and understand both files lmao.


---  
Let's have some fun now.
I made a new file and wrote two small functions to test if we could make function calls with the Cross-Compiler we have. Let's' checkout the code and the results. 


```C
void call() {
    func(0xdede);
}

int func(int arg) {
    return arg;
}
```

Now, this is what we get when we ```xxd``` the ```.o``` file of the program above.

```

00000000: 7f45 4c46 0101 0100 0000 0000 0000 0000  .ELF............
00000010: 0100 0300 0100 0000 0000 0000 0000 0000  ................
00000020: 8c01 0000 0000 0000 3400 0000 0000 2800  ........4.....(.
00000030: 0b00 0a00 5589 e58b 4508 5dc3 5589 e568  ....U...E.].U..h
00000040: dede 0000 e8fc ffff ff83 c404 90c9 c300  ................
00000050: 4743 433a 2028 474e 5529 2031 302e 332e  GCC: (GNU) 10.3.
00000060: 3000 0000 1400 0000 0000 0000 017a 5200  0............zR.
00000070: 017c 0801 1b0c 0404 8801 0000 1c00 0000  .|..............
00000080: 1c00 0000 0000 0000 0800 0000 0041 0e08  .............A..
00000090: 8502 420d 0544 c50c 0404 0000 1c00 0000  ..B..D..........
000000a0: 3c00 0000 0800 0000 1300 0000 0041 0e08  <............A..
000000b0: 8502 420d 054f c50c 0404 0000 0000 0000  ..B..O..........
000000c0: 0000 0000 0000 0000 0000 0000 0100 0000  ................
000000d0: 0000 0000 0000 0000 0400 f1ff 0000 0000  ................
000000e0: 0000 0000 0000 0000 0300 0100 0d00 0000  ................
000000f0: 0000 0000 0800 0000 1200 0100 1600 0000  ................
00000100: 0800 0000 1300 0000 1200 0100 0066 756e  .............fun
00000110: 2d63 616c 6c73 2e43 005f 5a34 6675 6e63  -calls.C._Z4func
00000120: 6900 5f5a 3463 616c 6c76 0000 1100 0000  i._Z4callv......
00000130: 0203 0000 2000 0000 0202 0000 4000 0000  .... .......@...
00000140: 0202 0000 002e 7379 6d74 6162 002e 7374  ......symtab..st
00000150: 7274 6162 002e 7368 7374 7274 6162 002e  rtab..shstrtab..
00000160: 7265 6c2e 7465 7874 002e 6461 7461 002e  rel.text..data..
00000170: 6273 7300 2e63 6f6d 6d65 6e74 002e 7265  bss..comment..re
00000180: 6c2e 6568 5f66 7261 6d65 0000 0000 0000  l.eh_frame......
00000190: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001a0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001b0: 0000 0000 1f00 0000 0100 0000 0600 0000  ................
000001c0: 0000 0000 3400 0000 1b00 0000 0000 0000  ....4...........
000001d0: 0000 0000 0100 0000 0000 0000 1b00 0000  ................
000001e0: 0900 0000 4000 0000 0000 0000 2c01 0000  ....@.......,...
000001f0: 0800 0000 0800 0000 0100 0000 0400 0000  ................
00000200: 0800 0000 2500 0000 0100 0000 0300 0000  ....%...........
00000210: 0000 0000 4f00 0000 0000 0000 0000 0000  ....O...........
00000220: 0000 0000 0100 0000 0000 0000 2b00 0000  ............+...
00000230: 0800 0000 0300 0000 0000 0000 4f00 0000  ............O...
00000240: 0000 0000 0000 0000 0000 0000 0100 0000  ................
00000250: 0000 0000 3000 0000 0100 0000 3000 0000  ....0.......0...
00000260: 0000 0000 4f00 0000 1300 0000 0000 0000  ....O...........
00000270: 0000 0000 0100 0000 0100 0000 3d00 0000  ............=...
00000280: 0100 0000 0200 0000 0000 0000 6400 0000  ............d...
00000290: 5800 0000 0000 0000 0000 0000 0400 0000  X...............
000002a0: 0000 0000 3900 0000 0900 0000 4000 0000  ....9.......@...
000002b0: 0000 0000 3401 0000 1000 0000 0800 0000  ....4...........
000002c0: 0600 0000 0400 0000 0800 0000 0100 0000  ................
000002d0: 0200 0000 0000 0000 0000 0000 bc00 0000  ................
000002e0: 5000 0000 0900 0000 0300 0000 0400 0000  P...............
000002f0: 1000 0000 0900 0000 0300 0000 0000 0000  ................
00000300: 0000 0000 0c01 0000 1f00 0000 0000 0000  ................
00000310: 0000 0000 0100 0000 0000 0000 1100 0000  ................
00000320: 0300 0000 0000 0000 0000 0000 4401 0000  ............D...
00000330: 4700 0000 0000 0000 0000 0000 0100 0000  G...............
00000340: 0000 0000                                ....

```

And this is the Binary file. 

```
00000000: 5589 e58b 4508 5dc3 5589 e568 dede 0000  U...E.].U..h....
00000010: e8eb ffff ff83 c404 90c9 c300 1400 0000  ................
00000020: 0000 0000 017a 5200 017c 0801 1b0c 0404  .....zR..|......
00000030: 8801 0000 1c00 0000 1c00 0000 c4ff ffff  ................
00000040: 0800 0000 0041 0e08 8502 420d 0544 c50c  .....A....B..D..
00000050: 0404 0000 1c00 0000 3c00 0000 acff ffff  ........<.......
00000060: 1300 0000 0041 0e08 8502 420d 054f c50c  .....A....B..O..
00000070: 0404 0000
```

Before we move ahead, let us simplify theabove code and examine it closely using ```ndiasm```

We use the following command to do so ,

```
ndisasm -b 32 function.bin
```
The output of the above command is really interesting.

```
00000000  55                push ebp
00000001  89E5              mov ebp,esp
00000003  B8BABA0000        mov eax,0xbaba
00000008  5D                pop ebp
00000009  C3                ret
```

Looks familiar, right?


Even if you cannot understand them, it is more than obvious to tell that the ```.o```
files hold a lot more information than the binary file. That's because they also have information about debugging etc. While the machine code doesn't.

Anyway, let's go a step forward and try declaring a variable.

---

After playing around and getting all nostalgic with the code I wrote I figured it's about time we step it up, again.


## Kernel 

We initially wrote our Kernel in Assembly and it was okay-ish.
Not the most advanced kernel but it did boot and worked just fine. 

Here's kernel in C which will print A on the screen.

```C
void dummy() {
    // This is a dummy function to create entry function for the kernel
}


void main() {
    char* v_mem = (char*) 0xb8000;
    *v_mem = 'X';
}
```
Now we need an Assembly file that will call the C file and ```exec``` it.
So let's write it.

```bash 
[bits 32]
[extern main] 
; The above line kind-of says that the entry point is 'main' in our kernel.c file.
; Read more about extern maybe.


call main 
; This line is calling the main function from our kernel.c file. 

jmp $

```

Let's compile the ```kernel.c``` file.

```
i686-elf-gcc -ffreestanding -c kernel.c -o kernel.o
```
And we'll compile the Kernel Entry file but we will not genereate a binary file, we will instead generate an ```elf``` file which will be linked to ```kernel.o```

We compile it with the following command:

```nasm kernel-e.asm -f elf -o kernel-e.o```

## True Potential 

Let's extract more from the Linker, one of the coolest tools in our arsenal. 

We will now bind both the object files that we generated in the previous two steps into a single Binary kernel.

```
i686-elf-ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
```

Our kernel wil be placed at ```0x1000``` in memory. Bootsector will need this information later on.

## Bootsector

Here's how the bootsector looks like

```
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; The same one we used when linking the kernel

    mov [BOOT_DRIVE], dl ; Remember that the BIOS sets us the boot drive in 'dl' on boot
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE 
    call print
    call print_nl

    call load_kernel ; read the kernel from disk
    call switch_to_pm ; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
    jmp $ ; Never executed

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"
%include "boot_sect_disk.asm"
%include "32bit-gdt.asm"
%include "32bit-print.asm"
%include "32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; Read from disk and store in 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET ; Give control to the kernel
    jmp $ ; Stay here when the kernel returns control to us (if ever)


BOOT_DRIVE db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; padding
times 510 - ($-$$) db 0
dw 0xaa55
```

I missed two which were rather important to make so I made them, I won't talk about them much. You can read the code and understand them really. hehe (I am just tired)

Let's compile the bootsector now

```
nasm bootsect.asm -f bin -o bootsect.bin
```

Let's link the Kernek & the bootsector file into one.

```
cat bootsect.bin kernel.bin > very-cool-os.bin
```

## Climax
Now is will run the Kernel image made in the previous step using qemu

```
qemu-system-i686 -fda very-cool-os.bin
```





