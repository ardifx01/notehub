from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
import bcrypt
from datetime import datetime
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME

app = Flask(__name__)
CORS(app)

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

# ======================
# 🔑 AUTH ENDPOINTS
# ======================

# 1. Sign Up
@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    nama = data["nama"]
    email = data["email"]
    password = bcrypt.hashpw(data["password"].encode("utf-8"), bcrypt.gensalt())
    foto = data.get("foto", "")

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "INSERT INTO users (nama, email, password, foto) VALUES (%s, %s, %s, %s)",
                (nama, email, password.decode("utf-8"), foto)
            )
            db.commit()
            user_id = cursor.lastrowid

    return jsonify({"message": "User created", "id": user_id})


# 2. Login
@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data["email"]
    password = data["password"].encode("utf-8")

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

    if user and bcrypt.checkpw(password, user["password"].encode("utf-8")):
        return jsonify({"message": "Login success", "user": user})
    else:
        return jsonify({"message": "Invalid credentials"}), 401


# 3. Edit data user
@app.route("/user/<int:user_id>", methods=["PUT"])
def edit_user(user_id):
    data = request.json
    nama = data.get("nama")
    email = data.get("email")
    foto = data.get("foto", "")

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "UPDATE users SET nama=%s, email=%s, foto=%s WHERE id=%s",
                (nama, email, foto, user_id)
            )
            db.commit()

    return jsonify({"message": "User updated"})


# ======================
# 📝 NOTE ENDPOINTS
# ======================

# 1. Upload note
@app.route("/note", methods=["POST"])
def upload_note():
    data = request.json
    user_id = data["user_id"]
    judul = data["judul"]
    isi = data["isi"]
    kategori = data.get("kategori", "")
    tanggal = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "INSERT INTO notes (user_id, judul, isi, kategori, tanggal) VALUES (%s,%s,%s,%s,%s)",
                (user_id, judul, isi, kategori, tanggal)
            )
            db.commit()
            note_id = cursor.lastrowid

    return jsonify({"message": "Note uploaded", "id": note_id})


# 2. Ambil semua note user tertentu
@app.route("/notes/<int:user_id>", methods=["GET"])
def get_user_notes(user_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes WHERE user_id=%s", (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)


# 3. Hapus note
@app.route("/note/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("DELETE FROM notes WHERE id=%s", (note_id,))
            db.commit()
    return jsonify({"message": "Note deleted"})


# 4. Ambil semua note
@app.route("/notes", methods=["GET"])
def get_all_notes():
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes")
            notes = cursor.fetchall()
    return jsonify(notes)


# 5. Simpan note orang lain
@app.route("/save_note", methods=["POST"])
def save_note():
    data = request.json
    user_id = data["user_id"]
    note_id = data["note_id"]

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "INSERT INTO saved_notes (user_id, note_id) VALUES (%s,%s)",
                (user_id, note_id)
            )
            db.commit()
            save_id = cursor.lastrowid

    return jsonify({"message": "Note saved", "id": save_id})


# 6. Ambil semua note yang disimpan user
@app.route("/saved_notes/<int:user_id>", methods=["GET"])
def get_saved_notes(user_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("""
                SELECT notes.* FROM saved_notes
                JOIN notes ON saved_notes.note_id = notes.id
                WHERE saved_notes.user_id=%s
            """, (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)


# ======================
# RUN APP
# ======================
if __name__ == "__main__":
    app.run(debug=True)
