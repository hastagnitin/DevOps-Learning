from flask import Flask
import mysql.connector

app = Flask(__name__)

@app.route("/")
def home():
    db = mysql.connector.connect(
        host="mysql",
        user="root",
        password="redhat",
        database="company"
    )

    cursor = db.cursor()

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS employee(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
    )
    """)

    cursor.execute("INSERT INTO employee(name) VALUES('Rahul')")
    db.commit()

    cursor.execute("SELECT * FROM employee")

    data = cursor.fetchall()

    return str(data)

app.run(host="0.0.0.0",port=5000)
