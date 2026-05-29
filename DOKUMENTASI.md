Perpustakaan App — Flutter

Aplikasi manajemen perpustakaan berbasis Flutter yang mengkonsumsi REST API dari Golang-Perpustakaan-Restful-API.

Stack
Bagian	Teknologi
Frontend	Flutter
State Management	Provider
HTTP Client	Dio
Local Storage	shared_preferences
Backend	Golang (Fiber + GORM + MySQL)
Auth	JWT
Struktur Folder Flutter
lib/
├── core/
│   ├── config/         # app_config.dart (baseUrl)
│   ├── network/        # dio_client.dart (JWT interceptor)
│   ├── theme/          # app_theme.dart, bg_painter.dart
│   └── utils/          # token_helper.dart, dio_error_parser.dart
├── models/             # base_response, auth, buku, jenis_buku, dst
├── services/           # API calls per modul
├── providers/          # State management per modul
└── screens/
    ├── auth/           # login_screen.dart
    ├── buku/
    ├── jenis_buku/
    ├── penulis_buku/
    ├── penerbit_buku/
    ├── peminjaman/
    └── denda/

Fitur
Login dengan JWT
CRUD Buku
CRUD Jenis Buku
CRUD Penulis Buku
CRUD Penerbit Buku
CRUD Peminjaman (+ Detail Peminjaman)
CRUD Denda
Auto redirect ke halaman Login jika sesi habis
Bottom Navigation (Dashboard, Buku, Peminjaman, Denda)
Dashboard dengan menu master (Jenis Buku, Penulis, Penerbit, Buku)
Banner auto-scroll tiap 5 detik
Konfigurasi Base URL

Ubah di lib/core/config/app_config.dart:

// Android Emulator
static const String baseUrl = 'http://10.0.2.2:8001/api/v1';

// Physical Device / iOS Simulator — ganti dengan IP komputer
static const String baseUrl = 'http://192.168.x.x:8001/api/v1';

Setup Backend (Golang)
Prasyarat
Go 1.18+
MySQL
Git
Langkah
git clone https://github.com/afrizal423/Golang-Perpustakaan-Restful-API
cd Golang-Perpustakaan-Restful-API
cp .env.example .env


Edit .env sesuaikan konfigurasi database:

DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=perpustakaan
APP_PORT=8001


Jalankan:

go run main.go

Bug yang Ditemukan dan Diperbaiki di Backend (Go)

Berikut adalah bug yang ditemukan selama pengembangan dan telah diperbaiki langsung di kode sumber Go:

1. Spasi di struct tag AlamatPenerbit

File: internal/infrastructure/http/v1/buku/buku_request/penerbit_buku_request.go

Sebelum:

AlamatPenerbit string ` json:"alamat_penerbit" validate:"required"`


Sesudah:

AlamatPenerbit string `json:"alamat_penerbit" validate:"required"`


Dampak: Ada spasi di awal struct tag sehingga Go tidak bisa mem-parse field alamat_penerbit dari JSON request body. Create dan Update penerbit selalu gagal dengan error "Data json yang diberikan salah!".

Berlaku untuk struct Penerbit_Buku_Request dan Penerbit_Buku_Request_Update.

2. Nama field IDpeminjaman (huruf p kecil)

File: internal/core/domain/peminjaman.go

Sebelum:

IDpeminjaman string `gorm:"column:id_peminjaman;size:26" json:"id_peminjaman"`


Sesudah:

IDPeminjaman string `gorm:"column:id_peminjaman;size:26" json:"id_peminjaman"`


Dampak: GORM tidak bisa resolve foreign key relasi antara struct DetailPinjam dan Peminjaman karena nama field tidak konsisten (Go bersifat case-sensitive untuk exported field).

3. Nama relasi Preload salah di GetDetailPeminjaman

File: internal/infrastructure/repository/mysql/peminjaman/peminjaman_repository.go

Sebelum:

err := r.db.Preload("Anggota").Preload("DtPeminjaman.BukuDetail").First(&peminjaman, "id_peminjaman = ?", id).Error


Sesudah:

err := r.db.Preload("Anggota").Preload("Details.BukuDetail").First(&peminjaman, "id_peminjaman = ?", id).Error


Dampak: DtPeminjaman adalah nama field di struct DetailPinjam, bukan di struct Peminjaman. Field relasi yang benar di struct Peminjaman adalah Details. GORM mengembalikan error "unsupported relations for schema Peminjaman" dengan HTTP 500 setiap kali endpoint GET /detail/:id dipanggil.

Catatan Android

Tambahkan di android/app/src/main/AndroidManifest.xml agar HTTP (non-HTTPS) bisa berjalan:

<uses-permission android:name="android.permission.INTERNET"/>

<application
    android:usesCleartextTraffic="true"
    ...>

Dependencies Flutter
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  cupertino_icons: ^1.0.2
