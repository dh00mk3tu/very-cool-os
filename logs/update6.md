
### Update 6: 22/04/2021

# Using the GCC Cross-Compiler 

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
i386-elf-gcc -ffreestanding -c function.c -o function.o
```





