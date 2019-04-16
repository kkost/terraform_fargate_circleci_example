#!/usr/bin/env python3

from flask import Flask

__version__ = "0.0.1"

def create_app():
    app = Flask(__name__)

    @app.route("/")
    def index():
        return "far out^H^H^Hgate, man\n" + __version__ + "\n"

    return app

def main():
    app = create_app()
    app.run(threaded=True,host='0.0.0.0',port=5000)

if __name__ == "__main__":
    main()
