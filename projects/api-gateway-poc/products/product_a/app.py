from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/example')
def hello_world():
    return jsonify({"message": "Hello, World! Product A"})


def lambda_handler():
    app.run()

    

if __name__ == "__main__":
    app.run()

