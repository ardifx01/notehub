from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
import bcrypt
from datetime import datetime
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

def validate_fields(data, required_fields):
    """Helper function untuk cek field wajib"""
    missing = [field for field in required_fields if field not in data or data[field] in [None, ""]]
    if missing:
        return False, f"Field(s) missing or empty: {', '.join(missing)}"
    return True, None


# ======================
# 🔑 AUTH ENDPOINTS
# ======================

@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    valid, error = validate_fields(data, ["nama", "email", "password"])
    if not valid:
        return jsonify({"error": error}), 400

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

            cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
            new_user = cursor.fetchone()

    return jsonify({"message": "User created", "user": new_user})


@app.route("/login", methods=["POST"])
def login():
    data = request.json
    valid, error = validate_fields(data, ["email", "password"])
    if not valid:
        return jsonify({"error": error}), 400

    email = data["email"]
    password = data["password"].encode("utf-8")

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

    if user and bcrypt.checkpw(password, user["password"].encode("utf-8")):
        return jsonify({"message": "Login success", "user": user})
    else:
        return jsonify({"error": "Invalid credentials"}), 401


@app.route("/user/<int:user_id>", methods=["PUT"])
def edit_user(user_id):
    data = request.json
    nama = data["nama"]
    email = data["email"]
    foto = data.get("foto", "")
    password = data.get("password")  # opsional

    with get_db_connection() as db:
        with db.cursor() as cursor:
            if password:  # kalau ada password baru
                hashed_pw = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
                cursor.execute(
                    "UPDATE users SET nama=%s, email=%s, foto=%s, password=%s WHERE id=%s",
                    (nama, email, foto, hashed_pw, user_id)
                )
            else:  # kalau tidak ada password → update biasa
                cursor.execute(
                    "UPDATE users SET nama=%s, email=%s, foto=%s WHERE id=%s",
                    (nama, email, foto, user_id)
                )
            db.commit()

    return jsonify({"message": "User updated"})


# ======================
# 📝 NOTE ENDPOINTS
# ======================

@app.route("/note", methods=["POST"])
def upload_note():
    data = request.json
    valid, error = validate_fields(data, ["user_id", "judul", "isi"])
    if not valid:
        return jsonify({"error": error}), 400

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


@app.route("/notes/<int:user_id>", methods=["GET"])
def get_user_notes(user_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes WHERE user_id=%s", (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)


@app.route("/note/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("DELETE FROM notes WHERE id=%s", (note_id,))
            db.commit()
    return jsonify({"message": "Note deleted"})


@app.route("/notes", methods=["GET"])
def get_all_notes():
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes")
            notes = cursor.fetchall()
    return jsonify(notes)


@app.route("/save_note", methods=["POST"])
def save_note():
    data = request.json
    valid, error = validate_fields(data, ["user_id", "note_id"])
    if not valid:
        return jsonify({"error": error}), 400

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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
