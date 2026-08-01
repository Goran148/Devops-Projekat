import os
import socket
import datetime
from flask import Flask, jsonify
import psutil

app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "message": "DevOps System Monitor API is running!",
        "hostname": socket.gethostname(),
        "timestamp": datetime.datetime.now().isoformat()
    })

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        "status": "UP",
        "healthy": True
    }), 200

@app.route('/metrics', methods=['GET'])
def metrics():
    return jsonify({
        "cpu_usage_percent": psutil.cpu_percent(interval=1),
        "memory_usage_percent": psutil.virtual_memory().percent,
        "disk_usage_percent": psutil.disk_usage('/').percent
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)