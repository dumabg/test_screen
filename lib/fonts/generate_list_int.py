import os

def convert_binary_to_text(binary_file_path): #, text_file_path):
    """Converts a binary file to a text file with comma-separated integers."""
    try:
        with open(binary_file_path, 'rb') as binary_file:
            binary_data = binary_file.read()

        int_list = list(binary_data)  # Convert bytes to a list of integers
        text_data = ','.join(map(str, int_list))  # Efficiently convert to string

        print(text_data)

    except FileNotFoundError:
        print(f"Error: Binary file not found at {binary_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

import argparse

def main():
    parser = argparse.ArgumentParser(description="Convert binary file to comma-separated integers in a text file.")
    parser.add_argument("-i", "--input", required=True, help="Path to the binary input file")
    args = parser.parse_args()

    convert_binary_to_text(args.input)

if __name__ == "__main__":
    main()