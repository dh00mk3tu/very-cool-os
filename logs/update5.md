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

## Installing Packages

Run the following command to run the install-depnd.sh script so that it can install all the required packages.

```./install-depn```

## Source Code 

We need to download the source code of GCC and Binutlis.

They are available here,

1. [binutlis](https://ftp.gnu.org/gnu/binutils/)
2. [gcc](https://ftp.gnu.org/gnu/gcc/gcc-10.3.0/)  

## Building Source

We have to build a toolset running on the host that will convert the source code into object files for our kernel.
I will install the compiler for myself only on the machine is a relative directory. 

```$HOME/opt/cross```

I honestly am scared to proceed further because I run the risk of messing up my host system's compiler and I use for work as well and I cannot risk messing it up right now, because technically am in office right now. 

:(

But meh, couldn't care less. 

It was a little confusing at first but then when I figured out what I was doing, I realised it was really easy.

BTW, I am not even over exaggerating, my head is spinning, skin is coming off my fingers(some infection I guess) and my wrists hurt. smh 

___
### binutils

#### Step 1 - Adding details to $PATH & $TARGET

```
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

#### Step 2 - Building binutils

cd to the directory where you downloaded the source codes of binutils.

Now,

```mkdir build-binutils```

Next, 

```
cd build-binutils
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
```

Here, change the x-y-z to the version number of the binutils you downloaded. 

Now,

```make```

This step will take a decent amount of time depending on your computer. Mine took about 7-8 minutes.

Last step of compiling binutils is to install the files we just made. We do this by:

```make install```

You shouldn't get any errors. If you do, solve them yourself or raise a pull request :V

___
### GCC

#### Step 1 - cd to src dir  

Change dir back to the source dir   

#### Step 2 - Check whether we made the binutils installation correctly 

```which -- $TARGET-as || echo $TARGET-as is not in the PATH```

Your output should look like this:

```/home/dh00mk3tu/opt/cross/bin/i686-elf-as```

#### Step 3 - Building gcc

```mkdir build-gcc```

Now, again a similar step like we did for binutils

```
cd build-gcc
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
```

Change x-y-z to the version you have downloaded.

Anyway, I got an error.

>configure: error: Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+.
Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify
their locations.  Source code for these libraries can be found at
their respective hosting sites as well as at
https://gcc.gnu.org/pub/gcc/infrastructure/.  See also
http://gcc.gnu.org/install/prerequisites.html for additional info.  If
you obtained GMP, MPFR and/or MPC from a vendor distribution package,
make sure that you have installed both the libraries and the header
files.  They may be located in separate packages.

Now let me spend another 1-2 hours trying to fix it.

Okay so after 2 minutes I figured out that I forgot to install MPFR and MPC. So I did it and we're good to go. 

Next step is to make from the Makefile generated in the previous step.

```make all-gcc```

The Above step made three more make files and I am supposed to build them as well to let me. 

Building gcc is going to take some time, apparently. Again, depending on your computer. At this point, I wish I had a R5 5600X and 32 gigs of RAM.

It also depends on what kind of Storage Device you're on. If I was on a SSD, it would've been a different story but right now I am on a 10 year old HDD@7200 RPM :')


The next three MakeFiles can be built using

```
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

---

The above build processes took following time on my pc: 

1. ```all-gcc              : 22m & 32s ```
2. ```all-target-libgcc    : 11s```
3. ```install-gcc          : 7s```
4. ```install-target-libgcc: <1s```

---
<br>

### Using the new Compiler 

To check if your installation was successful run the following command: 

```$HOME/opt/cross/bin/$TARGET-gcc --version```

Your output should look like this: 

```
i686-elf-gcc (GCC) 10.3.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

---

## Result

The compiler that we have installed won't be able to compile anything generic. You cannot include header files and write a ```hello-world.c``` program. We specifically mentioned while building out C compiler that we don't need them.  

We did it when we mentioned ```-without-headers```.

We did so because we need a freestanding executing environment and not a hosted one. In OS Development, I learnt that you need a freestanding environment. You can read more about it online I am not going to type it because my finger tips hurt for some reason(infection I guess).

To use the compiler I will add it to the $PATH

```export PATH="$HOME/opt/cross/bin:$PATH"```

I  will wind up this update for today.
In the next update we will attempt to execute C code on our kernel. 

I am aware that before we can do it, we need to set up a Linker and a Loader I guess. But we'll see to it.








