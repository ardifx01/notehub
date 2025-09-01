from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
import bcrypt
from datetime import datetime
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
import cloudinary.uploader
import cloudinary
import logging
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)
CORS(app, resources={r"/": {"origins": ""}})

cloudinary.config(
  cloud_name="dgtvpcslj",      
  api_key="298163539819314",    
  api_secret="DSrPDe6QTeHTobNVx9ufQ8ydgtE" 
)

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        charset="utf8mb4",
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
        with db.cursor() as cursor:   # pakai dictionary=True biar hasil dict
            cursor.execute(
                "INSERT INTO users (nama, email, password, foto) VALUES (%s, %s, %s, %s)",
                (nama, email, password.decode("utf-8"), foto)
            )
            db.commit()
            user_id = cursor.lastrowid

            cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
            new_user = cursor.fetchone()

    # ubah datetime ke isoformat
    if new_user and isinstance(new_user.get("tanggal_pembuatan_akun"), datetime):
        new_user["tanggal_pembuatan_akun"] = new_user["tanggal_pembuatan_akun"].isoformat()

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
        with db.cursor() as cursor:   # penting: dictionary=True
            cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

    if user and bcrypt.checkpw(password, user["password"].encode("utf-8")):
        if isinstance(user.get("tanggal_pembuatan_akun"), datetime):
            user["tanggal_pembuatan_akun"] = user["tanggal_pembuatan_akun"].isoformat()
        return jsonify({"message": "Login success", "user": user})
    else:
        return jsonify({"error": "Invalid credentials"}), 401


# endpoint update user
@app.route("/user/<int:user_id>", methods=["PUT"])
def edit_user(user_id):
    data = request.get_json()
    if not data:
        return jsonify({"message": "Request body kosong"}), 400

    nama = data.get("nama")
    email = data.get("email")
    password = data.get("password")
    foto_url = data.get("foto")

    # cek user lama
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
            user_lama = cursor.fetchone()

    if not user_lama:
        return jsonify({"message": "User tidak ditemukan"}), 404

    # fallback ke data lama kalau field kosong
    nama = nama or user_lama["nama"]
    email = email or user_lama["email"]
    foto_url = foto_url or user_lama["foto"]

    hashed_pw = (
        bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
        if password else None
    )

    # build query update
    query = "UPDATE users SET nama=%s, email=%s, foto=%s"
    params = [nama, email, foto_url]

    if hashed_pw:
        query += ", password=%s"
        params.append(hashed_pw)

    query += " WHERE id=%s"
    params.append(user_id)

    try:
        with get_db_connection() as db:
            with db.cursor() as cursor:
                cursor.execute(query, params)
                db.commit()

                # ambil data terbaru
                cursor.execute(
                    "SELECT id, nama, email, foto, tanggal_pembuatan_akun FROM users WHERE id=%s",
                    (user_id,),
                )
                updated_user = cursor.fetchone()

                if updated_user and isinstance(updated_user["tanggal_pembuatan_akun"], datetime):
                    updated_user["tanggal_pembuatan_akun"] = updated_user["tanggal_pembuatan_akun"].isoformat()

        return jsonify({
            "message": "User updated",
            "user": updated_user
        })
    except Exception as e:
        return jsonify({"message": f"Gagal update user: {e}"}), 500

# endpoint ambil user tertentu
@app.route("/user/<int:user_id>", methods=["GET"])
def get_user(user_id):
    with get_db_connection() as db:
        with db.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("SELECT id, nama, email, foto, tanggal_pembuatan_akun FROM users WHERE id=%s", (user_id,))
            user = cursor.fetchone()

            if user and isinstance(user["tanggal_pembuatan_akun"], datetime):
                    user["tanggal_pembuatan_akun"] = user["tanggal_pembuatan_akun"].isoformat()

    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify(user)

# ======================
# 📝 NOTE ENDPOINTS
# ======================

# endpoint buat note baru
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
    tanggal = datetime.now().isoformat()  

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "INSERT INTO notes (user_id, judul, isi, kategori, tanggal) VALUES (%s,%s,%s,%s,%s)",
                (user_id, judul, isi, kategori, tanggal)
            )
            db.commit()
            note_id = cursor.lastrowid

    return jsonify({"message": "Note uploaded", "id": note_id})

# endpoint ambil semua note user tertentu
@app.route("/notes/<int:user_id>", methods=["GET"])
def get_user_notes(user_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes WHERE user_id=%s", (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)


# endpoint hapus note tertentu
@app.route("/note/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("DELETE FROM notes WHERE id=%s", (note_id,))
            db.commit()
    return jsonify({"message": "Note deleted"})

# endpoint ambil semua note yang ada
@app.route("/notes", methods=["GET"])
def get_all_notes():
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes")
            notes = cursor.fetchall()
    return jsonify(notes)

# endpoint simpan note
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

@app.route("/unsave_note", methods=["DELETE"])
def unsave_note():
    data = request.json
    valid, error = validate_fields(data, ["user_id", "note_id"])
    if not valid:
        return jsonify({"error": error}), 400

    user_id = data["user_id"]
    note_id = data["note_id"]

    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "DELETE FROM saved_notes WHERE user_id=%s AND note_id=%s",
                (user_id, note_id)
            )
            db.commit()

            if cursor.rowcount == 0:  # kalau tidak ada baris terhapus
                return jsonify({"message": "Note not found in saved list"}), 404

    return jsonify({"message": "Note unsaved"})


# endpoint ambil note yang disimpan user tertentu
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