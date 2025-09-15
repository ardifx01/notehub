// =======================
// Ambil query parameter
// =======================
const urlParams = new URLSearchParams(window.location.search);
const userId = urlParams.get("user_id");
const userName = urlParams.get("user_name") || "User";
const noteId = urlParams.get("note_id");

// tampilkan nama user di halaman
document.getElementById("userName").innerText = userName;

// =======================
// Elemen container
// =======================
const temaAndalanContainer = document.getElementById("temaAndalan");
const temaSemuaContainer = document.getElementById("temaSemua");

// =======================
// Base URL API
// =======================
const baseUrl = "http://10.0.5.41:5000";
// const baseUrl = "https://ff2dbcc47e3c.ngrok-free.app";

// =======================
// Fungsi buat card tema
// =======================
function buatTemaCard(tema) {
  const div = document.createElement("div");
div.className = "tema-card";

  div.innerHTML = `
    <img src="${tema.thumbnail}" alt="">
    <div class="tema-info">
      <p>${tema.nama_tema}</p>
      <div class="rating">⭐ ${tema.rating}</div>
    </div>
  `;

  // klik card → buka modal detail
  div.addEventListener("click", () => showTemaDetail(tema));

  return div;
}

// =======================
// Fetch data dari API
// =======================
async function loadThemes() {
  try {
    const res = await fetch(`${baseUrl}/tema`);
    const data = await res.json(); // array langsung

    // contoh: tampilkan 3 pertama jadi andalan
    const featured = data.slice(0, 3);
    const all = data;

    temaAndalanContainer.innerHTML = "";
    temaSemuaContainer.innerHTML = "";

    featured.forEach((tema) =>
      temaAndalanContainer.appendChild(buatTemaCard(tema))
    );
    all.forEach((tema) =>
      temaSemuaContainer.appendChild(buatTemaCard(tema))
    );
  } catch (err) {
    console.error("❌ Gagal ambil data tema", err);
  }
}

// =======================
// Modal popup
// =======================
const modal = document.getElementById("temaModal");
const modalImage = document.getElementById("modalImage");
const modalNama = document.getElementById("modalNama");
const modalRating = document.getElementById("modalRating");
const closeBtn = document.querySelector(".close-btn");
const pilihTemaBtn = document.getElementById("pilihTemaBtn");

let temaTerpilih = null;

function showTemaDetail(tema) {
  temaTerpilih = tema;
  modalImage.src = tema.foto_url;
  modalNama.textContent = tema.nama_tema;
  modalRating.textContent = tema.rating;

  modal.style.display = "flex";
  document.body.classList.add("noscroll"); // 🔒 kunci scroll
}

closeBtn.onclick = () => {
  modal.style.display = "none";
  document.body.classList.remove("noscroll"); // 🔓 buka scroll
};

window.onclick = (e) => {
  if (e.target === modal) {
    modal.style.display = "none";
    document.body.classList.remove("noscroll");
  }
};

pilihTemaBtn.onclick = () => {
  if (temaTerpilih) {
    const data = { 
      note_id: noteId, 
      tema_link: temaTerpilih.foto_url 
    };

    console.log("📤 dikirim ke flutter/backend:", data);

    // kirim ke Flutter WebView kalau ada
    if (typeof ThemeChannel !== "undefined") {
      ThemeChannel.postMessage(JSON.stringify(data));
    } else {
      // fallback kirim ke backend API
      fetch(`${baseUrl}/save_tema`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      })
      .then(res => res.json())
      .then(result => {
        console.log("✅ Tema tersimpan:", result);
        alert("Tema berhasil dipilih!");
      })
      .catch(err => {
        console.error("❌ Gagal simpan tema:", err);
        alert("Gagal menyimpan tema, coba lagi.");
      });
    }

    // tutup modal + aktifkan scroll lagi
    modal.style.display = "none";
    document.body.classList.remove("noscroll");
  }
};


// =======================
// Jalankan saat load
// =======================
loadThemes();

// pastikan popup tertutup setiap kali halaman load
modal.style.display = "none";

