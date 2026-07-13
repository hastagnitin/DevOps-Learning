from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello World! Welcome to  Flask app."

@app.route('/about')
def about():
    return "This is a simple Flask application."

if __name__ == '__main__':
    app.run(debug=True)
