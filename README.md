# very-cool-os
This repo is to test out making an operating system from absolute scratch and it is not a Linux based operating system. Practicing Assembly and stuff for Astra OS.

Once we've booted our Kernel, our objective will be to switch to C to print strings on the Screen instead of Assembly; we will then proceed further with C for I/O operations. The project is taking help and inspiration from multiple sources like books, videos, articles and forums. So it's hard to list them all but I will try my best to list them while I document this project.

I'm learning myself and I will make mistakes as well. But I will learn from them so every sort of input is great help, really. 

With that said, god speed!

## Build Instructions 
#### On Windows
```bash 
./nasm.exe -f bin assembly_file.asm -o output_binfile.bin
```

I'm calling nasm as ./nasm.exe because I have not installed it globally. I installed both nasm & QEMU locally in the project directory.
Next step is to emulate the image file in QEMU.

Again, since QEMU is also locally installed, cd into the QEMU directory. Once done, run the following command.

```bash
./qemu-system-x86_64 output_binfile.bin
```
---
#### On Linux

On Linux it is fairly simple because both NASM and QEMU are installed globally by the package manager. 
```bash 
nasm -f bin assembly_file.asm -o output_binfile.bin
```

Again, let's emulate the image file. 
```bash
qemu-system -x86_64  output_binfile.bin
```

___
### Update 1: 06/04/2021
#### Writing Boot Sector.
<br>
Boot sector needs the magic number to check whether there is a Master Boot Record or not. The boot sector contains 512 MB of space. The simplest bootloader could be to write instructions that are first saved on the boot sector of the storage device. That is on (Cylinder 0, Head 0, Sector 0) 
<br>
Now, we write a loop to fill the 510 Bytes of the boot loader space and in the last 2 bytes we write the magic number i.e 
```bash 0xAA55```
<br>
This number is nothing special and just tells the bios that yes there is an OS here and it can load from here. Read more about the magic number [here](https://stackoverflow.com/questions/39972313/whats-so-special-about-0x55aa) & and [this](http://mbrwizard.com/thembr.php) page.


___
### Update 2: 09/04/2021
#### 32 Bit Print Mode.
<br>
Today we have two very clear types of Architectures available. ```x86``` which is an IP of Intel and ```AMD64``` which is an IP of AMD. Since we're just starting off and focused around the 32bit Arch which was first introduced as Intel's i386 in the 8086.
<br>
Clearly, we've taken the first step and managed to boot the kernel from the Boot Sector. Now our second step is to slowly transcend towards 32 bit arch.
<br>
At such low level, the potential and control we have over the computer is absolutely surreal. Though I was aware that the programmer really has a lot of power in his/her hands but the lowest level I ever had been before was with C while I was developing Sling Malware. Studying about pointers taught me that most of out computers potential technically goes waste if we're not coding properly. Now, at while learning and using assembly - it's absolutely ridiculous as to much power it gives us.
<br><br>
---
Assembly let's us fiddle with the individual registers on the processor. We have complete control over the brain of the computer.
With that said. Let's move ahead.

<br> 
Let's make use of 32 bit power.
I tired using the following, based on the I could gather from multiple sources. 
1. Registers
2. Memory Addressing 
3. Protected Memory 
4. Virtual Memory

And some other things that are very cool but too complicated for my smol brain to comprehend yet. 

<br>
I also realize that being curious is good but maybe not when you're dealing with Assembly. Because, even though we're emulating the Kernel right now using QEMU, if we were to run this on an actual 80286 Machine, we would lose our GDT. 
> GDT stands for Global Descriptor Table. It basically holds standardized value of of memory areas on the processor. Much like the magic number, which described that yes you can boot from here to the BIOS, this table describes the characteristics of the memory areas for better indexing. 

***
<br>
Anyway, back to the topic. Until now, I was storing individual characters on H & L registers from A TO B. 
But this time I used a different method to render the text on the screen(render isn't the right word, you'll know why).

<br>
VGA is also a memory module, and if that's the case, it must have a memory address as well and it does. VGA starts from ```0xb8000```. To be very honest, I have no idea how to translate that down to a non computer science person. But just understand that it is the physical address of VGA on the processor.
<br>

Let's say, I want to print the character "A", on the top left corner of the screen, and any character that might follow should come after it in the right direction.

Just a black screen with two characters starting from the top left. 

How do we reach that top corner?
It's very simple actually, more than I thought it'll be at least.
Let's say that our grid on the screen is 80x25.

```0xb8000  + 2 * (r * 80 + c)```

The above equation is used to access a specific character on the grid. It basically returns the location of that char. I won't go into how this works because

1. It's very intricate and will require a lot of background knowledge.
2. I myself couldn't understand it completely lmao

But one Important thing to know here is this that each character is of two bytes; hence 

```
0xb8000  +   2 * (r * 80 + c)
                |
                |
                This is the two bytes size of the character here
```

### Now, let's have a look at the code and evaluate it.
> (Any statement after ;(semicolon) is a comment. They're added to to explain the code)


```assembly
[bits 32]   ; using 32-bit protected mode. Here we've specified that we're in 32 bits. It's much like 
            ; including the header file in CC/++

; this is how constants are defined

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each character

; both VIDEO_MEMORY & WHITE_ON_BLACK are constants. Constants because we dont want their 
; value to change as they traverse throughout the program. 

; initialising the VGA and moving Now notice this.
; I declared VIDEO_MEMORY equal to ```0xb8000``` which is the address of the first
; character on the grid.  


print_string_pm:
    pusha ; push to the stack
    mov edx, VIDEO_MEMORY ; Here we're moving the address to the edx register. 

; Start of the print loop
print_string_pm_loop:
    mov al, [ebx]   ; [ebx] is the address of our character and we're moving it 
                    ; to the al register.
    mov ah, WHITE_ON_BLACK 
                    ; we're moving the second constant to the ah register.

    ; Before we move ahead, I'll tell you what has happened here.
    ; We have a 16 bit register ax with us which is devided in two ah & al.
    ;
    ; Understand it as follows.
    ;           -----------------
    ;    AX     |  AH   |  AL   |
    ;           -----------------
    ;   16bit       8b  +   8b
    ;
    ; Here AH is the high value in the register while AL is the low value.
    ; The total size of the character is 2 bytes, so in first part of our register 
    ; we've stored the address while on the other part we're storing the color details 
    ; i.e white on black.


    ; anyway, moving ahead 

    cmp al, 0 ; check if end of string
    je print_string_pm_done

    mov [edx], ax ; store character + attribute in video memory
    add ebx, 1 ; next char
    add edx, 2 ; next video memory position

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
```


___
### Update 3: 10/04/2021
#### GDT in Assembly.

First thing that one needs to understand before writing the Kernel is that you write it strictly keeping the processor in mind. Our Objective while writing our kernel is to make sure we make the best use of the Hardware we have. 

With that said, I need to remind you that we've started off writing our kernel for a CPU that strictly has x86 Arch.

With that out of the way, we need to set the mind clear that we'll be writing the GDT.

This update might be a little rough on the edges but let's start with it.

##### GDT 
Like I told in the previous update, GDT is something that is exclusive to the Intel instruction set and Arch. 
GDT stands for Global Descriptor Table. This table is a Data Structure which was first introduced with 8086 in the x86 arch. 

This Data Structure defines the characteristics of the memory area that are used when a program or an instruction is executed. 

> These memory areas are called Segments

You also call GDT as Segment Descriptor (I guess?)

Now, have a look at the image below.

![Image of GDT Table](/resources/SegmentDescriptor.svg)

There The descriptor table is divided into two. The Base Address section & the Segment Limit. Each half is 16bit making up for a 32 bit table.  
To access the the table one has to use the Index inside the GDT. this index is called Segment Selector.

To make my own GDT, I will make two segments, and the generally accepted approach when programming a GDT is to dedicate one half to code and other half to data. 

Though, I achieve this but I soon enough realized a grave mistake I did which I still don't know how to fix. Yet. 
The problem is that these two portions, theoretically and physically on the processor, overlap and I have no clue how to separate them but keep them in one table. 

Unlike the previous update where we left the Kernel in a state where booting it wasn't possible, with this GDT, our kernel will boot.

I also learnt that you can't just slap the GDT table on the processor and it'll work. We have to use the GDT Descriptor. 

A descriptor for a descriptor table lmao.
Anyway, I won't get into this much but for this while, we just nee to know that ```lgdt``` is used to access the GDT. 

Our kernel is still running in 16 bit real mode and to switch to 32 bit protected mode we need the GDT.

I also learnt that once we are in 32 bit mode, we can no longer use the BIOS or use the BIOS to make calls.  

```bash 
gdt_start: ; dont remove the labels, they are very important 
           ; the GDT starts with a null 8-byte
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36

gdt_code: 
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

; Above two are the simplest possible data structures. They both hold 16bit data. 

gdt_end:

; GDT descriptor

; index to use GDT 
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
    dd gdt_start ; address (32 bit)

; define some constants for later use. I have no idea what they ; ; are. I just know they do something very important. 

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
```

Now that we have out GDT, we can boot our Kernel in 32bit mode but can no longer use the BIOS so no I/O


It took me 6 hours and 21 Minutes to understand the GDT and how it is supposed to work and then around 40 minutes more on the clock to write the GDT code with me searching the internet at every step. 
Worth the headache though.  
=======
___
### Update 3: 20/04/2021
#### GDT in Assembly.
