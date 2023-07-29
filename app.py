from app import create_app
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = create_app()

if __name__ == '__main__':
    app.debug = True
    app.config['DEBUG'] = True
    app.run()