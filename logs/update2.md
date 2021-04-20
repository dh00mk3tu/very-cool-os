___
### Update 2: 09/04/2021
#### [32 Bit Print Mode.](logs/update2.md)
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
