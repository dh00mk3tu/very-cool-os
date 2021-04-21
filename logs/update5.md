___

### Update 5: 21/04/2021

# Creating Dev Envm for the Kernel

Yesterday was a great day that we managed to boot into 32 bit protected mode and I suppose the road ahead will only get more complex until we reach to a point where we can execute our C code and leave Assembly because it was great fot the while it lasted :V

My most prominent source of information and guide is the OSDev Wiki and a couple of other books I found; and clearly the next step in the process is to create an Developer Environment for our kernel.

Understanding why making a dev environment is important is important. Let me explain;

## The Highs & Lows

Assembly gets converted to machine code by the processor and basic executions are made but to perform more complex tasks and to actually create a program, for instance let's say a Calculator, writing that in Assembly is complicated and moving ahead with such a low level programming language is not recommended. 

We HAVE to switch to a high level programming language once we've booted. But the processor cannot convert/compile a high level because it simply cannot understand it. In order to run our C code, our kernel needs to have a C compiler. This compiler, which is ```gcc``` is going to convert our high level code to machine code that our processor can understand and execute.

### The Target 

We need to tell the code what target or platform are we writing the code for. It's the most important task that we need to do.
We have to use the cross-compiler unless we are developing on our own OS. 

Why exactly will we run into trouble if we won't use a cross compiler?
Let's say we decide not to use the cross compiler and I use GCC to create the Corss Compiler. Here in, when we will build the x-compiler, it'll think that is it making the code for the host machine, which in my case in Linux.

But our kernel isn't Linux.

When we'll build the kernel using GCC, it will use the Linux ```libgcc```, and it will make bad juju linux assumptions.
 
## The GCC Cross Compiler


