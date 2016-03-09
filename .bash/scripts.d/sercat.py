#!/usr/bin/env python2

import sys
import argparse
import serial
import sys
import select
import time

# Create command line arg parser
parser = argparse.ArgumentParser()
parser.add_argument('-b', dest='baudrate', type=int, help='Baudrate to use for'
        ' serial device', default=38400)
parser.add_argument('-d', dest='device', nargs='?', default='/dev/tty.usbserial',
        help='Serial device to use')
parser.add_argument('-r', dest='raw', action='store_true', help='Print data ' \
        'normal or including hex chars', default=False)

# Do actual parsing
args = parser.parse_args()

# Open serial device with params
ser = serial.Serial(port=args.device, baudrate=args.baudrate)


# Check if stdin data is present
hasStdin = select.select([sys.stdin,],[],[],0.0)[0]

try:
    if hasStdin:
        # Write to serial device
        for line in sys.stdin.readlines():
            ser.write(line)
            time.sleep(0.05)
            #print line
    else:
        while True:
            bytesToRead = ser.inWaiting()
            if bytesToRead:
                bytes = ser.read(bytesToRead)
                data = repr(bytes) if args.raw else bytes
                print data

except KeyboardInterrupt:
    print 'Exiting...'
    ser.close()


