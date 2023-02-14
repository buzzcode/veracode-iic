from flask  import Flask, request, make_response
import json

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello There"

@app.route('/register', methods = ['OPTIONS', 'POST'])
def register():
    rq = request
    if rq.method == 'OPTIONS':
        resp = make_response('OPTIONS handled')
        resp.headers['Access-Control-Allow-Origin'] = '*'
        resp.headers['Access-Control-Allow-Methods'] = 'GET, POST'
        resp.headers['Access-Control-Allow-Headers'] = 'Content-Type'

        return resp

    # else POST
    data = rq.data.decode()
    userinfo = json.loads(data)

    resp = make_response('User registered successfully')
    resp.headers['Access-Control-Allow-Origin'] = '*'

    # send user data to database (yeah, yeah...  threading, async calls, etc.)

    
    return resp

# for running/debugging locally
if __name__ == '__main__':
    app.run()