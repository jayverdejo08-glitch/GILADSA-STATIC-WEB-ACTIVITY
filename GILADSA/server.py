"""
GILADSA Secure Prototype Server
================================
A lightweight HTTP server with built-in HTTP Basic Authentication to ensure
ONLY YOU can access your prototype when exposed to the local network or internet.

Usage:
    python server.py [--port 8080] [--user admin] [--password YOUR_PASSWORD]
"""

import sys
import os
import base64
import argparse
from http.server import HTTPServer, SimpleHTTPRequestHandler

DEFAULT_PORT = 8080
DEFAULT_USER = "admin"
DEFAULT_PASS = "giladsa2026"

class AuthHandler(SimpleHTTPRequestHandler):
    username = DEFAULT_USER
    password = DEFAULT_PASS

    def __init__(self, *args, **kwargs):
        # Serve from prototype directory
        prototype_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "prototype")
        super().__init__(*args, directory=prototype_dir, **kwargs)

    def do_HEAD(self):
        if not self.authenticate():
            return
        super().do_HEAD()

    def do_GET(self):
        if not self.authenticate():
            return
        super().do_GET()

    def do_POST(self):
        if not self.authenticate():
            return
        super().do_POST()

    def authenticate(self):
        auth_header = self.headers.get("Authorization")
        if auth_header is None:
            self.send_auth_required()
            return False

        try:
            auth_type, encoded = auth_header.split(" ", 1)
            if auth_type.lower() != "basic":
                self.send_auth_required()
                return False

            decoded = base64.b64decode(encoded).decode("utf-8")
            username, password = decoded.split(":", 1)

            if username == self.username and password == self.password:
                return True
        except Exception:
            pass

        self.send_auth_required()
        return False

    def send_auth_required(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="GILADSA Secure Prototype Access"')
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"<h1>401 Unauthorized</h1><p>Access restricted. Please provide valid credentials.</p>")

def get_local_ip():
    try:
        import socket
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"

def run(port=DEFAULT_PORT, username=DEFAULT_USER, password=DEFAULT_PASS):
    AuthHandler.username = username
    AuthHandler.password = password
    server_address = ("0.0.0.0", port)
    httpd = HTTPServer(server_address, AuthHandler)

    local_ip = get_local_ip()

    print("=" * 65)
    print("  ⚡ GILADSA SECURE PROTOTYPE SERVER")
    print("=" * 65)
    print(f"  On this PC:      http://localhost:{port}")
    print(f"  From phone/Wi-Fi: http://{local_ip}:{port}")
    print("-" * 65)
    print(f"  Username:        {username}")
    print(f"  Password:        {password}")
    print("=" * 65)
    print("  Protected by HTTP Basic Auth. Only devices on your Wi-Fi")
    print("  with these credentials can view the prototype.")
    print("=" * 65)

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run authenticated prototype server.")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT, help="Port to listen on")
    parser.add_argument("--user", type=str, default=DEFAULT_USER, help="Username for Basic Auth")
    parser.add_argument("--password", type=str, default=DEFAULT_PASS, help="Password for Basic Auth")
    args = parser.parse_args()

    run(port=args.port, username=args.user, password=args.password)
