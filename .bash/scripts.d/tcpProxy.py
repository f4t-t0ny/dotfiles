#!/usr/bin/env python2
# This is a simple port-forward / proxy, written using only the default python
# library. If you want to make a suggestion or fix something you can contact-me
# at voorloop_at_gmail.com
# Distributed over IDC(I Don't Care) license
import socket
import select
import time
import sys
from binascii import hexlify

# Changing the buffer_size and delay, you can improve the speed and bandwidth.
# But when buffer get to high or delay go too down, you can broke things
buffer_size = 4096
delay = 0.0001

class Forward:
    def __init__(self):
        self.forward = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def start(self, host, port):
        try:
            self.forward.connect((host, port))
            return self.forward
        except Exception, e:
            print e
            return False

class TheServer:
    input_list = []
    channel = {}

    def __init__(self, port=5578 , forwardPort=5577):
        self.port = port
        self.host = '0.0.0.0'
        self.forward_to = ('127.0.0.1', forwardPort)
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((self.host, self.port))
        self.server.listen(200)
        print "listening on 0.0.0.0:" +str(port)
        print "forwarding to " +self.forward_to[0] + ":" + str(self.forward_to[1])

    def main_loop(self):
        self.input_list.append(self.server)
        while 1:
            time.sleep(delay)
            ss = select.select
            inputready, outputready, exceptready = ss(self.input_list, [], [])
            for self.s in inputready:
                if self.s == self.server:
                    self.on_accept()
                    break

                self.data = self.s.recv(buffer_size)
                if len(self.data) == 0:
                    self.on_close()
                    break
                else:
                    self.on_recv()

    def on_accept(self):
        forward = Forward().start(self.forward_to[0], self.forward_to[1])
        clientsock, clientaddr = self.server.accept()
        if forward:
            print clientaddr, "has connected"
            self.input_list.append(clientsock)
            self.input_list.append(forward)
            self.channel[clientsock] = forward
            self.channel[forward] = clientsock
        else:
            print "Can't establish connection with remote server.",
            print "Closing connection with client side", clientaddr
            clientsock.close()


    def on_close(self):
        print self.s.getpeername(), "has disconnected"
        #remove objects from input_list
        self.input_list.remove(self.s)
        self.input_list.remove(self.channel[self.s])
        out = self.channel[self.s]
        # close the connection with client
        self.channel[out].close()  # equivalent to do self.s.close()
        # close the connection with remote server
        self.channel[self.s].close()
        # delete both objects from channel dict
        del self.channel[out]
        del self.channel[self.s]

    def on_recv(self):
        data = self.data
        # here we can parse and/or modify the data before send forward
        #print self.s.getsockname(), self.host, self.port
        if self.s.getsockname()[1] == self.port:
            prefix = '<--' 
        else:
            prefix = '-->'

        #print prefix + ' ' + ' '.join(hexlify(c) for c in data)
        #print prefix + ' ' + repr(data)
        print prefix + ' ' + data

        self.channel[self.s].send(data)

if __name__ == '__main__':
    if len(sys.argv) == 1:
        server = TheServer()
    elif len(sys.argv) == 2 and sys.argv[1] in ['-h', '--help']:
      print 'Usage: tcpProxy.py 4567 4568'
      sys.exit(1)
    elif len(sys.argv) == 3:
      server = TheServer(port=int(sys.argv[1]), forwardPort=int(sys.argv[2]))
    else: 
        raise Exception('Wrong number of arguments')
        exit(1)
    try:
        server.main_loop()
    except KeyboardInterrupt:
        print "Ctrl C - Stopping server"
        sys.exit(1)
