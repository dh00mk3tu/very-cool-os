___

### Update 4: 20/04/2021

#### [Entering 32 Bit Protected Mode.](logs/update4.md)

Coming here after 10 days or so, but the time off the tracks was really necessary.

I did a very dire mistake and kept emulating for ```80206``` never actually realisizing that it is only a 16 bit microprocessor.
I was supposed to use ```80306```.

A lot of time and energy rendered useless because I was trying to achieve and run 32 bit instructions on a 16 bit machine.

Not Cool.

So I decided to get off the track and devote time to reading, learning and understanding the structure of the processor.
So that's what I did.

Now, with a little bit of confidence in this I was ready to move ahead.

In the last update I wrote the GDT because I techinically messed it up, but we managed to write our own bare minimum GDT with taking help from almost entirety of the internet. 

Now I have to boot into 32 Bit protected mode.
Before we move ahead, you need to know about Interupts & Pipelining; and you need to know about them properly to be able to understand what is happening.

But to save time, I'll give you an overview of what they are. You can read about them later on when you see feel like (if).

Interputs in a modern digital computer is basically a flag, that once raised by the processor which basically a response to an event which requires attention from the software/program. Consider an interupt like the ```break``` statement in the C/C++ language. It breaks the current loop or flow of control and forces the program out of it.

An interupt does the same thing but with the processor. It is a signal sent to the processor which "interupts" the current process. Both hardware and software can create interupts. 

Pipelining on the other hand, you can say is the precursor to multi-processing and multi-threading. 

More information, and better information available [here](https://web.cs.iastate.edu/~prabhu/Tutorial/PIPELINE/pipe_title.html)

Pipelining is a technique where multiple instructions are bundled or overlapped in ```exec```.

>Pipelining is an implementation technique where multiple instructions are overlapped in execution. The computer pipeline is divided in stages. Each stage completes a part of an instruction in parallel. The stages are connected one to the next to form a pipe - instructions enter at one end, progress through the stages, and exit at the other end.

Pipelining does not decrease the time for individual instruction execution. Instead, it increases instruction throughput. The throughput of the instruction pipeline is determined by how often an instruction exits the pipeline. 


It was becoming more and more tedious and had for me to wrap my head around the struture of 80306.
