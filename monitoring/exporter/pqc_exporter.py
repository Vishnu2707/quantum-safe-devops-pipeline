from http.server import BaseHTTPRequestHandler, HTTPServer
import random, time

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/metrics':
            rsa_time = round(random.uniform(1.0, 2.0), 3)
            falcon_time = round(random.uniform(2.0, 3.0), 3)
            cpu_usage = round(random.uniform(20, 80), 2)

            metrics = f"""# HELP pqc_ssh_rsa_handshake_seconds RSA handshake time
# TYPE pqc_ssh_rsa_handshake_seconds gauge
pqc_ssh_rsa_handshake_seconds {rsa_time}

# HELP pqc_ssh_falcon_handshake_seconds Falcon handshake time
# TYPE pqc_ssh_falcon_handshake_seconds gauge
pqc_ssh_falcon_handshake_seconds {falcon_time}

# HELP pqc_cpu_usage_percent CPU usage percent
# TYPE pqc_cpu_usage_percent gauge
pqc_cpu_usage_percent {cpu_usage}
"""

            self.send_response(200)
            # Correct header required by Prometheus
            self.send_header('Content-Type', 'text/plain; version=0.0.4; charset=utf-8')
            self.end_headers()
            self.wfile.write(metrics.encode('utf-8'))
        else:
            self.send_error(404, 'Endpoint not found')

if __name__ == '__main__':
    print("PQC Metrics Exporter running on port 9091")
    server = HTTPServer(('0.0.0.0', 9091), Handler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down exporter...")
        server.server_close()
