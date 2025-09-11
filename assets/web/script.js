// ambil semua query parameter dari URL
const urlParams = new URLSearchParams(window.location.search);

// ambil nilai user_id dan user_name dari URL
const userId = urlParams.get('user_id'); 
const userName = urlParams.get('user_name') || "User"; 

// tampilkan nama user di halaman
document.getElementById('userName').innerText = userName;

// ambil container
const temaAndalanContainer = document.getElementById('temaAndalan');
const temaSemuaContainer = document.getElementById('temaSemua');

// base Url rest api
const baseUrl = 'http://10.0.5.41:5000';

// fungsi buat card tema
function buatTemaCard(tema) {
  return `
    <div class="tema-card" onclick="pilihTema('${tema.foto_url}')">
      <img src="${tema.thumbnail}" alt="">
      <div class="tema-info">
        <p>${tema.nama_tema}</p>
        <div class="rating">⭐ ${tema.rating}</div>
      </div>
    </div>
  `;
}

// fetch data dari API
// fetch data dari API
async function loadThemes() {
  try {
    const res = await fetch(`${baseUrl}/tema`);
    const data = await res.json();

    // kalau backend balikin object { temas: [...] }
    // ambil isinya, kalau langsung array biarin aja
    const temas = Array.isArray(data) ? data : data.temas;

    if (!temas) {
      throw new Error("Response tidak punya array tema");
    }

    // contoh: tampilkan 3 pertama jadi andalan
    const featured = temas.slice(0, 3);
    const all = temas;

    temaAndalanContainer.innerHTML = featured.map(buatTemaCard).join('');
    temaSemuaContainer.innerHTML = all.map(buatTemaCard).join('');
  } catch (err) {
    console.error("Gagal ambil data tema", err);
  }
}


/* fungsi dipanggil saat user klik salah satu tema */
function pilihTema(temaLink) {
  const data = { userId, temaLink }; // user id ikut dikirim

  if (typeof ThemeChannel !== "undefined") {
    // kirim ke flutter
    ThemeChannel.postMessage(JSON.stringify(data));
  } else {
    // fallback kalau buka di browser biasa
    alert("Tema dipilih: " + temaLink + " (User ID: " + userId + ")");
  }
}

// jalankan saat halaman load
loadThemes();
