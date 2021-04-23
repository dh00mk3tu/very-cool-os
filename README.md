# very-cool-os
This repo is to test out making an operating system from absolute scratch and it is not a Linux based operating system. Practicing Assembly and stuff for Astra OS.

Once we've booted our Kernel, our objective will be to switch to C to print strings on the Screen instead of Assembly; we will then proceed further with C for I/O operations. The project is taking help and inspiration from multiple sources like books, videos, articles and forums. So it's hard to list them all but I will try my best to list them while I document this project.

I'm learning myself and I will make mistakes as well. But I will learn from them so every sort of input is great help, really. 

With that said, god speed!

___
## Updates 
<!-- To center the table - start -->

|         Update Date       |                       Title                  |
| --------------------------|:--------------------------------------------:|
| Update 1: 06/04/2021      | [Writing Boot Sector.](logs/update1.md)      |
| Update 2: 09/04/2021      | [32 Bit Print Mode.](logs/update2.md)        |
| Update 3: 10/04/2021      | [GDT in Assembly.](logs/update3.md)          |
| Update 4: 20/04/2021      | [Entering 32 Bit Protected Mode.](logs/update4.md)|
| Update 5: 21/04/2021      | [Cross-Compiler.](logs/update5.md)|
| Update 6: 22/04/2021      | [C The Kernel.](logs/update6.md)|

<!-- To Center the table - end -->

___
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



