from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import AutoModelForSequenceClassification, AutoTokenizer
from arabert.preprocess import ArabertPreprocessor
import torch
import sqlite3

app = Flask(__name__)
CORS(app)

# --- Setting up the updated database ---
def init_db():
    conn = sqlite3.connect('users_data.db')
    cursor = conn.cursor()
     # Users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    ''')
    # New log table for saving analytics for each user
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_email TEXT NOT NULL,
            comment TEXT NOT NULL,
            result TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_email) REFERENCES users (email)
        )
    ''')
    conn.commit()
    conn.close()

init_db()

# --- Model Settings ---
model_path = "my_model_archive" 
model_name = "aubmindlab/bert-base-arabertv02"

try:
    tokenizer = AutoTokenizer.from_pretrained(model_path, local_files_only=True)
    model = AutoModelForSequenceClassification.from_pretrained(model_path, local_files_only=True)
    prep_object = ArabertPreprocessor(model_name=model_name)
    print("✅ ")
except Exception as e:
    print(f"❌    : {e}")

label_map = {0: "إيجابي ✅", 1: "سلبي ❌", 2: "محايد ⚠️"}

# --- User Paths ---
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json
    try:
        conn = sqlite3.connect('users_data.db')
        cursor = conn.cursor()
        cursor.execute('INSERT INTO users (name, email, password) VALUES (?, ?, ?)', 
                       (data.get('name'), data.get('email'), data.get('password')))
        conn.commit()
        return jsonify({'message': 'Success'}), 201
    except:
        return jsonify({'error': 'Email already exists'}), 400
    finally:
        conn.close()

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    conn = sqlite3.connect('users_data.db')
    cursor = conn.cursor()
    cursor.execute('SELECT name, email FROM users WHERE email=? AND password=?', 
                   (data.get('email'), data.get('password')))
    user = cursor.fetchone()
    conn.close()
    if user:
        return jsonify({'name': user[0], 'email': user[1]}), 200
    return jsonify({'error': 'Invalid credentials'}), 401

# --- History Paths ---
@app.route('/save_analysis', methods=['POST'])
def save_analysis():
    data = request.json
    email = data.get('email')
    comment = data.get('comment')
    result = data.get('result')
    try:
        conn = sqlite3.connect('users_data.db')
        cursor = conn.cursor()
        cursor.execute('INSERT INTO history (user_email, comment, result) VALUES (?, ?, ?)', 
                       (email, comment, result))
        conn.commit()
        return jsonify({'status': 'Saved to database'}), 201
    finally:
        conn.close()

@app.route('/get_history/<email>', methods=['GET'])
def get_history(email):
    conn = sqlite3.connect('users_data.db')
    cursor = conn.cursor()

    # Retrieve records sorted from newest to oldest
    cursor.execute('SELECT comment, result FROM history WHERE user_email=? ORDER BY timestamp DESC', (email,))
    rows = cursor.fetchall()
    conn.close()
    
    history_list = [{"comment": r[0], "result": r[1]} for r in rows]
    return jsonify(history_list)

# --- Prediction Path ---
@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    text = data.get('text', '')
    preprocessed_text = prep_object.preprocess(text)
    inputs = tokenizer(preprocessed_text, return_tensors="pt")
    with torch.no_grad():
        outputs = model(**inputs)
    prediction = outputs.logits.argmax(-1).item()
    return jsonify({'label': label_map.get(prediction, "إيجابي ✅")})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)