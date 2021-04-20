___
### Update 3: 10/04/2021
#### [GDT in Assembly.](logs/update3.md)

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
