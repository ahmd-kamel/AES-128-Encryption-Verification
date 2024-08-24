#include <stdio.h>
#include <stdint.h>
#include <string.h>

// AES S-box
static const uint8_t sbox[256] = {
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
};

// AES Rcon
static const uint8_t rcon[10] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36};

// Key expansion function prototypes
void KeyExpansion(const uint8_t* key, uint8_t* roundKeys);

// AES-128 function prototypes
void AddRoundKey(uint8_t* state, const uint8_t* roundKey);
void SubBytes(uint8_t* state);
void ShiftRows(uint8_t* state);
void MixColumns(uint8_t* state);
void AES128_Encrypt(uint8_t* state, const uint8_t* key);

// Helper function prototypes
void hex_to_bytes(const char* hex_str, uint8_t* byte_array, size_t byte_array_len);
void bytes_to_hex(const uint8_t* byte_array, char* hex_str, size_t byte_array_len);
uint8_t xtime(uint8_t x);

// Perform AES encryption
char* reference_model(const char* data_hex, const char* key_hex) {
    static char ciphertext_hex[33];  // 32 hex characters + 1 for null terminator
    uint8_t data[16];
    uint8_t key[16];

    // Convert input hex strings to byte arrays
    hex_to_bytes(data_hex, data, 16);
    hex_to_bytes(key_hex, key, 16);

    // Perform AES-128 encryption
    AES128_Encrypt(data, key);

    // Convert the encrypted data (ciphertext) back to a hex string
    bytes_to_hex(data, ciphertext_hex, 16);

    // Return the ciphertext hex string
    return ciphertext_hex;
}

// AES functions implementation
void KeyExpansion(const uint8_t* key, uint8_t* roundKeys) 
{
    uint8_t temp[4];
    uint8_t i, j;
    memcpy(roundKeys, key, 16); // First round key is the key itself
    for (i = 16; i < 176; i += 4) 
    {
        memcpy(temp, roundKeys + i - 4, 4);
        if (i % 16 == 0)
         {
            // Rotate
            uint8_t t = temp[0];
            temp[0] = temp[1];
            temp[1] = temp[2];
            temp[2] = temp[3];
            temp[3] = t;
            // SubBytes
            for (j = 0; j < 4; j++) 
            {
                temp[j] = sbox[temp[j]];
            }
            temp[0] ^= rcon[(i / 16) - 1];
        }
        roundKeys[i] = roundKeys[i - 16] ^ temp[0];
        roundKeys[i + 1] = roundKeys[i - 15] ^ temp[1];
        roundKeys[i + 2] = roundKeys[i - 14] ^ temp[2];
        roundKeys[i + 3] = roundKeys[i - 13] ^ temp[3];
    }
}

void AddRoundKey(uint8_t* state, const uint8_t* roundKey) 
{
    for (int i = 0; i < 16; i++) 
    {
        state[i] ^= roundKey[i];
    }
}

void SubBytes(uint8_t* state) 
{
    for (int i = 0; i < 16; i++) 
    {
        state[i] = sbox[state[i]];
    }
}

void ShiftRows(uint8_t* state) 
{
    uint8_t temp;

    // Shift row 1
    temp = state[1];
    state[1] = state[5];
    state[5] = state[9];
    state[9] = state[13];
    state[13] = temp;

    // Shift row 2
    temp = state[2];
    state[2] = state[10];
    state[10] = temp;
    temp = state[6];
    state[6] = state[14];
    state[14] = temp;

    // Shift row 3
    temp = state[3];
    state[3] = state[15];
    state[15] = state[11];
    state[11] = state[7];
    state[7] = temp;
}

uint8_t xtime(uint8_t x) 
{
    return (x << 1) ^ ((x >> 7) & 1 ? 0x1B : 0);
}

void MixColumns(uint8_t* state) 
{
    uint8_t temp[16];
    for (int i = 0; i < 4; i++) 
    {
        int j = i * 4;
        temp[j] = xtime(state[j]) ^ xtime(state[j + 1]) ^ state[j + 1] ^ state[j + 2] ^ state[j + 3];
        temp[j + 1] = state[j] ^ xtime(state[j + 1]) ^ xtime(state[j + 2]) ^ state[j + 2] ^ state[j + 3];
        temp[j + 2] = state[j] ^ state[j + 1] ^ xtime(state[j + 2]) ^ xtime(state[j + 3]) ^ state[j + 3];
        temp[j + 3] = xtime(state[j]) ^ state[j] ^ state[j + 1] ^ state[j + 2] ^ xtime(state[j + 3]);
    }
    memcpy(state, temp, 16);
}

void AES128_Encrypt(uint8_t* state, const uint8_t* key) 
{
    uint8_t roundKeys[176];
    KeyExpansion(key, roundKeys);

    AddRoundKey(state, roundKeys);

    for (int i = 1; i < 10; ++i) 
    {
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state, roundKeys + (16 * i));
    }

    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state, roundKeys + 160);
}

// Helper functions implementation
void hex_to_bytes(const char* hex_str, uint8_t* byte_array, size_t byte_array_len) 
{
    for (size_t i = 0; i < byte_array_len; i++) 
    {
        sscanf(hex_str + 2 * i, "%2hhx", &byte_array[i]);
    }
}

void bytes_to_hex(const uint8_t* byte_array, char* hex_str, size_t byte_array_len) 
{
    for (size_t i = 0; i < byte_array_len; i++) 
    {
        sprintf(hex_str + 2 * i, "%02X", byte_array[i]);
    }
    hex_str[2 * byte_array_len] = '\0'; // Null terminate the string
}
