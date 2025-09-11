from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql
import bcrypt
from datetime import datetime
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME
import logging
import cloudinary
logging.basicConfig(level=logging.DEBUG)

# ======================
# 🚀 FLASK APP SETUP
# ======================
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})  # aktifkan CORS supaya API bisa diakses frontend

# ======================
# ☁️ CLOUDINARY SETUP
# ======================
cloudinary.config(
  cloud_name="dgtvpcslj",      
  api_key="298163539819314",    
  api_secret="DSrPDe6QTeHTobNVx9ufQ8ydgtE" 
)

# ======================
# 🔌 DATABASE CONNECTION
# ======================
def get_db_connection():
    """Buka koneksi ke MySQL"""
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor  # hasil query otomatis dict
    )

# ======================
# 🛠️ HELPER FUNCTION
# ======================
def validate_fields(data, required_fields):
    """Cek field wajib ada & tidak kosong"""
    missing = [field for field in required_fields if field not in data or data[field] in [None, ""]]
    if missing:
        return False, f"Field(s) missing or empty: {', '.join(missing)}"
    return True, None


# ======================
# 🔑 AUTH ENDPOINTS
# ======================

# endpoint sign up
@app.route("/signup", methods=["POST"])
def signup():
    """Daftar user baru"""
    data = request.json
    valid, error = validate_fields(data, ["nama", "email", "password"])
    if not valid:
        return jsonify({"error": error}), 400

    nama = data["nama"]
    email = data["email"]
    password = bcrypt.hashpw(data["password"].encode("utf-8"), bcrypt.gensalt())  # hash password
    foto = data.get("foto", "")

    # simpan user ke database
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(
                "INSERT INTO users (nama, email, password, foto) VALUES (%s, %s, %s, %s)",
                (nama, email, password.decode("utf-8"), foto)
            )
            db.commit()
            user_id = cursor.lastrowid  # ambil id user baru

            # ambil data user baru
            cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
            new_user = cursor.fetchone()

    # ubah datetime ke isoformat biar bisa di-JSON
    if new_user and isinstance(new_user.get("tanggal_pembuatan_akun"), datetime):
        new_user["tanggal_pembuatan_akun"] = new_user["tanggal_pembuatan_akun"].isoformat()

    return jsonify({"message": "User created", "user": new_user})


@app.route("/login", methods=["POST"])
def login():
    """Login user"""
    data = request.json
    valid, error = validate_fields(data, ["email", "password"])
    if not valid:
        return jsonify({"error": error}), 400

    email = data["email"]
    password = data["password"].encode("utf-8")

    # cari user berdasarkan email
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()

    # verifikasi password
    if user and bcrypt.checkpw(password, user["password"].encode("utf-8")):
        if isinstance(user.get("tanggal_pembuatan_akun"), datetime):
            user["tanggal_pembuatan_akun"] = user["tanggal_pembuatan_akun"].isoformat()
        return jsonify({"message": "Login success", "user": user})
    else:
        return jsonify({"error": "Invalid credentials"}), 401


# ======================
# 👤 USER ENDPOINTS
# ======================

@app.route("/user/<int:user_id>", methods=["PUT"])
def edit_user(user_id):
    """Update data user"""
    data = request.get_json()
    if not data:
        return jsonify({"message": "Request body kosong"}), 400

    nama = data.get("nama")
    email = data.get("email")
    password = data.get("password")
    foto_url = data.get("foto")

    # cek apakah user ada
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE id=%s", (user_id,))
            user_lama = cursor.fetchone()

    if not user_lama:
        return jsonify({"message": "User tidak ditemukan"}), 404

    # fallback: pakai data lama kalau field kosong
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

    if hashed_pw:  # update password kalau ada
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
    

@app.route("/user/<int:user_id>", methods=["GET"])
def get_user(user_id):
    """Ambil data user berdasarkan ID"""
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

@app.route("/note", methods=["POST"])
def upload_note():
    """Buat note baru"""
    data = request.json
    valid, error = validate_fields(data, ["user_id", "judul", "isi"])
    if not valid:
        return jsonify({"error": error}), 400

    user_id = data["user_id"]
    judul = data["judul"]
    isi = data["isi"]
    kategori = data.get("kategori", "")
    tanggal = datetime.now().isoformat()  

    # simpan note
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
    """Ambil semua note milik user tertentu"""
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes WHERE user_id=%s", (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)


@app.route("/note/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    """Hapus note berdasarkan ID"""
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("DELETE FROM notes WHERE id=%s", (note_id,))
            db.commit()
    return jsonify({"message": "Note deleted"})


@app.route("/notes", methods=["GET"])
def get_all_notes():
    """Ambil semua note yang ada di database"""
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT * FROM notes")
            notes = cursor.fetchall()
    return jsonify(notes)


@app.route("/fyp_notes", methods=["GET"])
def get_notes():
    search = request.args.get("search")
    kategori = request.args.get("kategori")

    if not search and not kategori:
        # default → ambil 1 bulan terakhir
        query = """
            SELECT * FROM notes
            WHERE tanggal >= NOW() - INTERVAL 1 MONTH
            ORDER BY tanggal DESC
        """
        params = []

    elif search and kategori:
        # kalau ada search + kategori → tanpa batas waktu
        query = """
            SELECT * FROM notes
            WHERE kategori = %s
              AND (LOWER(judul) LIKE %s OR LOWER(isi) LIKE %s)
            ORDER BY tanggal DESC
        """
        like_pattern = f"%{search.lower()}%"
        params = [kategori, like_pattern, like_pattern]

    elif search:
        # hanya search → tanpa batas waktu
        query = """
            SELECT * FROM notes
            WHERE LOWER(judul) LIKE %s OR LOWER(kategori) LIKE %s OR LOWER(isi) LIKE %s
            ORDER BY tanggal DESC
        """
        like_pattern = f"%{search.lower()}%"
        params = [like_pattern, like_pattern, like_pattern]

    elif kategori:
        # hanya kategori → tanpa batas waktu
        query = """
            SELECT * FROM notes
            WHERE kategori = %s
            ORDER BY tanggal DESC
        """
        params = [kategori]

    # jalankan query
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute(query, params)
            notes = cursor.fetchall()

    return jsonify(notes)


@app.route("/save_note", methods=["POST"])
def save_note():
    """Simpan note ke daftar saved_notes"""
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
    """Hapus note dari daftar saved_notes"""
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


@app.route("/saved_notes/<int:user_id>", methods=["GET"])
def get_saved_notes(user_id):
    """Ambil semua note yang disimpan user"""
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("""
                SELECT notes.* FROM saved_notes
                JOIN notes ON saved_notes.note_id = notes.id
                WHERE saved_notes.user_id=%s
            """, (user_id,))
            notes = cursor.fetchall()
    return jsonify(notes)



# =====================
# 🌐 WEB APP ENDPOINTS
# =====================

@app.route("/tema", methods=["GET"])
def get_tema():
    """Ambil semua tema yang ada di database"""
    with get_db_connection() as db:
        with db.cursor() as cursor:
            cursor.execute("SELECT id, nama_tema, foto_url, thumbnail, rating FROM tema")
            rows = cursor.fetchall()

            # Ambil nama kolom
            columns = [desc[0] for desc in cursor.description]

            # Convert ke list of dict
            temas = [dict(zip(columns, row)) for row in rows]

    return jsonify(temas)


@app.route("/upload_image", methods=["POST"])
def upload_image():
    """Simpan URL gambar (sudah ada di Cloudinary) ke database"""
    data = request.json
    if not data or "url" not in data:
        return jsonify({"error": "No image URL provided"}), 400

    image_url = data["url"]
    
    try:
        with get_db_connection() as db:
            with db.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO foto_url (url, uploaded_at) VALUES (%s, NOW())",
                    (image_url,)
                )
                db.commit()
                image_id = cursor.lastrowid

        return jsonify({"message": "Image saved", "id": image_id, "url": image_url})
    except Exception as e:
        logging.error(f"Database error: {e}")
        return jsonify({"error": "Failed to save image"}), 500

# ======================
# 🚀 RUN APP
# ======================

@app.route("/")
def home():
    return jsonify({"message": "Hello dari Flask + Ngrok!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
