void dummy() {
    // This is a dummy function to create entry function for the kernel
}


void main() {
    char* v_mem = (char*) 0xb8000;
    *v_mem = 'X';
}
