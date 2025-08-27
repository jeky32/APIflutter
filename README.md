
# 📱 API Flutter University  

## 👤 Identitas  
- **Nama  :** Zacky Noor Faizi
- **Kelas :** XII RPL 2 
- **No Absen :** 34
---

## 📸 Hasil Project  

![Screenshot](assets/screenshots/project.png)  


---

## ✨ Deskripsi  
Aplikasi ini dibuat menggunakan **Flutter** untuk menampilkan daftar universitas dari berbagai negara.  
Data diambil dari **API gratis [Hipolabs Universities](http://universities.hipolabs.com/)** tanpa token.  

Fitur utama:  
- 🌍 Cari universitas berdasarkan **negara**  
- 🔍 Pencarian realtime (nama universitas / negara / provinsi)  
- 🎨 Tampilan modern dengan **Material 3 (light & dark theme)**  
- 🔗 Bisa langsung membuka website resmi universitas  

---

## 📡 API yang Digunakan  

Aplikasi ini menggunakan **[Hipolabs Universities API](http://universities.hipolabs.com/)** (gratis, tanpa token).  

- **Endpoint Utama:**  
  [http://universities.hipolabs.com/search](http://universities.hipolabs.com/search)  

- **Contoh request dengan parameter negara:**  
  [http://universities.hipolabs.com/search?country=Indonesia](http://universities.hipolabs.com/search?country=Indonesia)  

- **Contoh respon JSON:**  
  ```json
  [
    {
      "name": "Universitas Indonesia",
      "country": "Indonesia",
      "state-province": null,
      "web_pages": ["http://www.ui.ac.id/"]
    }
  ]
````

---

## 🚀 Cara Menjalankan Project

### 1. Persiapan

Pastikan sudah menginstall:

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Android Studio / VS Code (dengan Flutter & Dart plugin)
* Emulator Android atau device fisik

### 2. Clone Repository

```bash
git clone https://github.com/username/APIflutter-University.git
cd APIflutter-University
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Jalankan di Emulator / Device

```bash
flutter run
```

### 5. Build APK (opsional)

Jika ingin menghasilkan file APK:

```bash
flutter build apk --release
```

---

## 🛠 Dependencies

* [http](https://pub.dev/packages/http) → ambil data dari API
* [url\_launcher](https://pub.dev/packages/url_launcher) → membuka link website universitas
* [cupertino\_icons](https://pub.dev/packages/cupertino_icons) → tambahan ikon iOS

---

## 📋 Rencana Pengembangan

* [ ] Tambah fitur **favorit** universitas
* [ ] Tambah **penyimpanan offline** dengan database lokal
* [ ] UI lebih interaktif dengan animasi

---

## 👨‍💻 Author

Nama : Zacky Noor Faizi
Kelas : XII RPL 2
No Absen : 34

```
