# very-cool-os
This repo is to test out making an operating system from absolute scratch and it is not a Linux based operating system. Practicing Assembly and stuff for Astra OS  

## Build Instructions 
#### On Windows
```./nasm.exe -f bin assembly_file.asm -o output_binfile.bin```

I'm calling nasm as ./nasm.exe because I have not installed it globally. I installed both nasm & QEMU locally in the project directory.
Next step is to emulate the image file in QEMU.

Again, since QEMU is also locally installed, cd into the QEMU directory. Once done, run the following command.

```./qemu-system-x86_64 output_binfile.bin```
---
#### On Linux

On Linux it is fairly simple because both NASM and QEMU are installed globally by the package manager. 
```nasm -f bin assembly_file.asm -o output_binfile.bin```

Again, let's emulate the image file. 
```qemu-system -x86_64  output_binfile.bin```

___
### Update 1: 06/04/2021
Writing Boot Sector.
Boot sector needs the magic number to check whether there is a Master Boot Record or not. 

