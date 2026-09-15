from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        mensaje = "<h1>Servidor Python Custom | Desplegado con Terraform y Docker</h1>"
        self.wfile.write(mensaje.encode('utf-8'))

print("Iniciando servidor en puerto 5000...")
server = HTTPServer(('0.0.0.0', 5000), SimpleHandler)
server.serve_forever()