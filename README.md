# very-cool-os
This repo is to test out making an operating system from absolute scratch and it is not a Linux based operating system. Practicing Assembly and stuff for Astra OS  

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
Writing Boot Sector.
Boot sector needs the magic number to check whether there is a Master Boot Record or not. The boot sector contains 512 MB of space. The simplest bootloader could be to write instructions that are first saved on the boot sector of the storage device. That is on Cylinder 0, Head 0, Sector 0. 
<br>
Now, we write a loop to fill the 510 Bytes of the boot loader space and in the last 2 bytes we write the magic number i.s 
``` bash 0xAA55 ```
<br>
This number is nothing special and just tells the bios that yes there is an OS here and it can load from here. Read more about the magic number [here](https://stackoverflow.com/questions/39972313/whats-so-special-about-0x55aa) & and [this](http://mbrwizard.com/thembr.php) page.

