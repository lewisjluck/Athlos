from flask import Flask, render_template, request, session

app = Flask(__name__)

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.secret_key = 'ulaanbaataar'

@app.route("/")
def index():
    return render_template("homepage.html")
