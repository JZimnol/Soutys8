import sys
import time
import serial
import pprint
import string
import logging
import argparse
import coloredlogs
import serial.tools.list_ports
from binascii import unhexlify

AVAILABLE_PORTS = [i[0] for i in serial.tools.list_ports.comports()]


class PrintColor:
    GREEN = '\033[92m'
    ORANGE = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'


# Print iterations progress
# Source: https://stackoverflow.com/questions/3173320/text-progress-bar-in-terminal-with-block-characters
# (this function has been modified for thesis purposes)
def printProgressBar (iteration, total, prefix = 'Flashing progress:', suffix = 'Complete', decimals = 1, length = 50,
                      fill = '█', printEnd = "\r"):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    if iteration/total < 0.33:
        print(f'\r{prefix} |{PrintColor.RED}{bar}{PrintColor.ENDC}| {percent}% {suffix}', end = printEnd)
    elif iteration/total < 0.66:
        print(f'\r{prefix} |{PrintColor.ORANGE}{bar}{PrintColor.ENDC}| {percent}% {suffix}', end = printEnd)
    else:
        print(f'\r{prefix} |{PrintColor.GREEN}{bar}{PrintColor.ENDC}| {percent}% {suffix}', end = printEnd)
    # Print New Line on Complete
    if iteration == total:
        print()


def characterize_line(line: str) -> tuple[int, int, int, str]:
    """
    Parse .hex file line and split it into a byte count, starting adddres, record type and data.
    More info: https://scienceprog.com/shelling-the-intel-8-bit-hex-file-format/
    @params:
        line  - Required  : .hex file line
    @return:
        tuple(data byte count, starting adddres, record type, data)
    """
    byte_count = int(line[1:3], 16)
    address = int(line[3:7], 16)
    record_type = int(line[7:9])
    data = line[9:]
    if data == "":
        data = "none"
    return byte_count, address, record_type, data


def remove_checksum(file_data: list[str]) -> list[str]:
    """
    Removes newline characters and checksums from given .hex file.
    @params:
        file_data  - Required  : list containing raw .hex file lines
    @return:
        stripped file content
    """
    ret_file_data = [line[:-3] for line in file_data]

    return ret_file_data


def file_content_check(file_data: list[str]):
    """
    Check if input file has proper .hex file format.
    @params:
        file_data  - Required  : list containing raw .hex file lines
    @return:
        0 on success
    """
    for line in file_data:
        if line[0] != ':' or line[-1] != '\n' or not all(c in string.hexdigits for c in line[1:-1]):
            return 1
    return 0


def main():
    logger = logging.getLogger(__name__)
    coloredlogs.install(fmt='%(asctime)s, %(name)s:%(lineno)d %(levelname)s %(message)s')

    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--port",
                        help="serial port with connected FPGA board",
                        choices=AVAILABLE_PORTS,
                        required=True)
    parser.add_argument("-f", "--hex-file",
                        help="full .hex file path",
                        required=True)
    parser.add_argument("-b", "--baud",
                        help="serial port baudrate",
                        required=True)
    args = parser.parse_args()

    try:
        with open(args.hex_file, "r") as file:
            hex_file_data = file.readlines()
    except Exception as e:
        logger.error(f"{e}")
        return 1

    if file_content_check(hex_file_data):
        logger.error("Invalid file format.")
        return 1
    print("Hex file content:")
    pprint.pprint(hex_file_data)

    hex_file_data = remove_checksum(hex_file_data)

    data_dict = {}
    for line in hex_file_data:
        byte_count, address, record_type, data = characterize_line(line)
        print(f"Byte count: 0x{byte_count:02x}, address: 0x{address:04x} record type: 0x{record_type:02x}, " +
              f"data: {data}")
        if record_type != 0:
            continue
        j = 0
        for i in range(byte_count):
            data_dict[i+address] = data[j:j+2].lower()
            j += 2

    logger.info(f"Number of bytes to write: {len(data_dict)}")

    try:
        ret_value = 0
        ser = serial.Serial(args.port, args.baud, timeout=0.02)
        for byte_number, byte_value in enumerate(data_dict.values()):
            ser.write(unhexlify(byte_value))
            bytes_received = ser.read()
            status = (unhexlify(byte_value) == bytes_received)
            if not status:
                print()
                logger.error(f"Byte: {byte_number}, sent: 0x{byte_value}, received: 0x{bytes_received.hex()}")
                ret_value = 1
                break
            printProgressBar(byte_number + 1, len(data_dict))
            time.sleep(0.001)
    except Exception as e:
        logger.error(f"{e}")
        ret_value = 1
    finally:
        if 'ser' in locals():
            ser.close()

    if not ret_value:
        logger.info("Flashed successfully.")

    return ret_value


if __name__ == '__main__':
    sys.exit(main())
