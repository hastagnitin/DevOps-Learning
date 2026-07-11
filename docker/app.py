from flask import Flask
import redis

app = Flask(__name__)

r = redis.Redis(host="redis", port=6379)

@app.route("/")
def home():
    r.set("message", "Welcome Docker Compose!")
    return r.get("message").decode()

app.run(host="0.0.0.0", port=5000)
