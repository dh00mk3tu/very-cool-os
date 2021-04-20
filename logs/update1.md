___
### Update 1: 06/04/2021
#### [Writing Boot Sector.](logs/update1.md)
<br>
Boot sector needs the magic number to check whether there is a Master Boot Record or not. The boot sector contains 512 MB of space. The simplest bootloader could be to write instructions that are first saved on the boot sector of the storage device. That is on (Cylinder 0, Head 0, Sector 0) 
<br>
Now, we write a loop to fill the 510 Bytes of the boot loader space and in the last 2 bytes we write the magic number i.e 
```bash 0xAA55```
<br>
This number is nothing special and just tells the bios that yes there is an OS here and it can load from here. Read more about the magic number [here](https://stackoverflow.com/questions/39972313/whats-so-special-about-0x55aa) & and [this](http://mbrwizard.com/thembr.php) page.