#!/usr/bin/env python2
# vim: set ft=python:

from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler

class RequestHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        print("\n----- Request Start ----->\n")
        print(self.path)
        print(self.headers)
        print("<----- Request End -----\n")
        
        self.send_response(200)
        self.connection.close()
        
    def do_POST(self):
        
        request_path = self.path
        
        print("\n----- Request Start ----->\n")
        print(request_path)
        
        request_headers = self.headers
        content_length = request_headers.getheaders('content-length')
        length = int(content_length[0]) if content_length else 0
        
        print(request_headers)
        print(self.rfile.read(length))
        print("<----- Request End -----\n")
        
        self.send_response(200)
    
    do_PUT = do_POST
    do_DELETE = do_GET
        
def main():
    import sys
    import argparse

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('-H', dest='host', help='Host to run on', default='0.0.0.0')
    parser.add_argument('-p', dest='port', type=int, help='Server port', default=9000)
    args = parser.parse_args()

    # Copy to vars
    port = args.port
    host = args.host
    
    # Start server and print startup message
    print('Listening on ' +host +':%s' % port)
    server = HTTPServer((host, port), RequestHandler)
    server.serve_forever()

        
if __name__ == "__main__":
    main()
