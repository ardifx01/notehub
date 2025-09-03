# 📓 Notehub

![GitHub repo size](https://img.shields.io/github/repo-size/FajarFarel/notehub)
![GitHub stars](https://img.shields.io/github/stars/FajarFarel/notehub?style=social)
![GitHub last commit](https://img.shields.io/github/last-commit/FajarFarel/notehub)

<img width="1240" height="649" alt="notehubMockup" src="https://github.com/user-attachments/assets/a7c0a723-018a-4e85-b43c-855d9a6aeade" />

---

Aplikasi **Notehub** yang dimana pengguna dapat membuat sebuah catatan tentang apapun dan di sebarkan ke seluruh internet. Aplikasi ini juga menyediakan berbagai macam fitur dan halaman yang dikemas dengan UI yang interaktif dan sangat ramah akan pengguna baru

---

## 🧩 Fitur Utama

- ✒ Membuat note baru
- 👁 Membaca note pengguna lain
- 🔍 Jelajahi ribuan note 
- 🔖 Simpan note favorit
- 📆 Kalender frekuensi menulis note

---

## 🛠️ Teknologi yang Digunakan

### 📱 Frontend (Flutter)

- Flutter SDK
- [`http`](https://pub.dev/packages/http) – komunikasi API
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) – penyimpanan lokal
- [`get x`](https://pub.dev/packages/get) – manajemen state
- [`foto`](https://pub.dev/packages/image_picker) - mengambil foto untuk profile

### 🌐 Backend (Flask)

- REST API
- Ngrox

## 📂 Penyimpanan (Database)

- MySQL
- Cloudinary

---

## 🗃️ Struktur Database

### 📘 Tabel users
```sql
id, nama, email, password, foto, tanggal_pembuatan_akun
```

### 📗 Tabel notes
```sql
id, user_id, judul, isi, kategori, tanggal
```

### 📕 Tabel save_notes
```sql
id, user_id, note_id
```

---

## 👥 Kontributor

- 👨‍💻 **Wahyu** - Pengembang Frontend (PM)
- 👨‍💻 **Fajar** – Pengembang Backend  
- 🤖 **Leo** – Asisten AI  

---

## Lisensi

Proyek ini dilisensikan sebagai perangkat lunak terbuka (**Open Source**).  
Seluruh fitur perangkat lunak ini dapat di akses dengan gratis tanpa pungutan biaya 
📩 Hubungi pengembang untuk info lebih lanjut.  
[Lihat Lisensi](License)
