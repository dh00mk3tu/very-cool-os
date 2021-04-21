___

### Update 5: 21/04/2021

# Creating Dev Envm for the Kernel

Yesterday was a great day that we managed to boot into 32 bit protected mode and I suppose the road ahead will only get more complex until we reach to a point where we can execute our C code and leave Assembly because it was great fot the while it lasted :V

My most prominent source of information and guide is the OSDev Wiki and a couple of other books I found; and clearly the next step in the process is to create an Developer Environment for our kernel.

Understanding why making a dev environment is important is important. Let me explain;

## The Highs & Lows

Assembly gets converted to machine code by the processor and basic executions are made but to perform more complex tasks and to actually create a program, for instance let's say a Calculator, writing that in Assembly is complicated and moving ahead with such a low level programming language is not recommended. 

We HAVE to switch to a high level programming language once we've booted. But the processor cannot convert/compile a high level because it simply cannot understand it. In order to run our C code, our kernel needs to have a C compiler. This compiler, which is ```gcc``` is going to convert our high level code to machine code that our processor can understand and execute.

## The Target 

We need to tell the code what target or platform are we writing the code for. It's the most important task that we need to do.
We have to use the cross-compiler unless we are developing on our own OS. 

Why exactly will we run into trouble if we won't use a cross compiler?
Let's say we decide not to use the cross compiler and I use GCC to create the Corss Compiler. Here in, when we will build the x-compiler, it'll think that is it making the code for the host machine, which in my case in Linux.

But our kernel isn't Linux.

When we'll build the kernel using GCC, it will use the Linux ```libgcc```, and it will make bad juju linux assumptions.

## The GCC Cross Compiler

> Generally speaking, a cross-compiler is a compiler that runs on platform A (the host), but generates executables for platform B (the target). These two platforms may (but do not need to) differ in CPU, operating system, and/or executable format.

IN order to completly isolate our kernel from our current OS, we'll be building the GCC x-compiler for a rather generic target ```i686-elf```.

---
Basic System Information (screenfetch)

1. Host: Ubuntu 20.10 groovy
2. Kernel: x86_64 Linux 5.8.0-50-generic
3. Uptime: 21h 8m
4. Shell: zsh 5.8
5. RAM: 11165MiB / 16017MiB (~RAM usage is relative)
6. CPU: AMD Ryzen 5 2600X Six-Core @ 12x 3.7GHz

---

Before proceeding ahead(if you are), clone the ```resource-check.sh``` file from the repo. 

I wrote that script, and it will check whether all the  necessary files/packages are installed on your system or not (Linux only)

Seriously if you're trying to do it on a Windows machine please stop.

The script will only check if those files/packages exist or not. You will have to install them manually. For that, clone the ```install-depnd.sh``` and execute it.

This script will install all the necessary packages.

We also need to have the following packages as a must*

    1.  gmp
    2.  mpfr
    3.  libmpc
    4.  gcc
    5.  g++
    6.  Make
    7.  Bison
    8.  Flex
    9.  mpc
    10. texinfo
    11. isl 
    12. CLoog






