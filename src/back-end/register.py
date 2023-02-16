from flask  import Flask, request, make_response
#from flask_cors import CORS, cross_origin
import json
import time

app = Flask(__name__)
#app.config['CORS_HEADERS'] = 'Content-Type'
#cors = CORS(app, resources={r"/register/*": {"origins": "*", "allow_headers": "*", "expose_headers": "*"}})

@app.route('/')
def hello():
    return "Hello There"

@app.route('/register', methods = ['OPTIONS', 'POST'])
#@cross_origin()
def register():
    rq = request

    print(f"request: {rq.method}")
    if rq.method == 'OPTIONS':
        resp = make_response('OPTIONS handled')
        resp.headers['Access-Control-Allow-Origin'] = '*'
        resp.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
        resp.headers['Access-Control-Allow-Headers'] = 'Content-Type'

        return resp

    # else POST
    data = rq.data.decode()
    userinfo = json.loads(data)

    # send user data to database (yeah, yeah...  threading, async calls, etc.)
    print(f"userinfo: firstname: {userinfo['firstname']}, lastname: {userinfo['lastname']}")

    resp = make_response('User registered successfully')
    # multiple CORS headers not allowed (if the OPTIONS sends one)
    # comment out if using @cross_origin()
    resp.headers['Access-Control-Allow-Origin'] = '*'      

    return resp

# for running/debugging locally
if __name__ == '__main__':
    t = time.localtime()
    now = time.strftime("%A %B %-d,%Y %H:%M:%S", t)
    print(f"Started: {now}")
    app.run(host="0.0.0.0")