from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route('/info')
def get_info():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    return jsonify({
        'container_hostname': hostname,
        'container_ip': ip_address
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)