import random

def generate_hexadecimal_digits(length=32):
    hex_digits = ''.join(random.choice('0123456789abcdef') for _ in range(length))
    return hex_digits.upper()

if __name__ == "__main__":
    hex_digits = generate_hexadecimal_digits()
    with open('data.txt', 'w') as file:
        file.write(hex_digits)

    hex_digits = generate_hexadecimal_digits()
    with open('key.txt', 'w') as file:
        file.write(hex_digits)   
