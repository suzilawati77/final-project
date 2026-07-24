# PRD — Sistem Pinjaman Buku KPT

**Versi:** 0.1 · **Tarikh:** 24 Julai 2026 · **Platform:** Flutter (Material 3), Dart

Andaian yang disahkan: tempoh pinjaman **14 hari**, pembaharuan **sekali sahaja** (+14 hari).

---

## 1. Ringkasan

Aplikasi mudah alih untuk kakitangan KPT meminjam dan memulangkan buku di Pusat Sumber KPT.
Aplikasi memaparkan senarai buku, membolehkan pendaftaran pengguna, merekod peminjaman dan
pemulangan, serta memaparkan senarai pinjaman semasa.

Masalah yang diselesaikan:

- **Pertindihan pinjaman** — bilangan salinan tersedia dikurangkan setiap kali pinjaman dibuat;
  pinjaman disekat apabila salinan tersedia = 0 atau pengguna sudah meminjam buku yang sama.
- **Kelewatan pemulangan** — tarikh akhir dipaparkan dan pinjaman lewat ditanda **Lewat**.

Skop: satu peranti, satu sesi, data dalam ingatan (hardcoded). Tiada log masuk, tiada pangkalan
data, tiada backend.

---

## 2. Pengguna & Keperluan

**Pengguna sasaran:** Penjawat Awam di KPT (peminjam). Tiada peranan pentadbir dalam skop ini.

1. Sebagai kakitangan KPT, saya mahu mendaftarkan maklumat diri saya (nama, no. IC, jawatan,
   bahagian) supaya setiap pinjaman dapat dikaitkan dengan saya.
2. Sebagai kakitangan KPT, saya mahu melihat senarai buku beserta bilangan salinan yang masih ada
   supaya saya tahu buku itu boleh dipinjam atau tidak.
3. Sebagai kakitangan KPT, saya mahu meminjam buku dan melihat tarikh akhir pinjaman supaya saya
   tidak lewat memulangkannya.
4. Sebagai kakitangan KPT, saya mahu melihat senarai pinjaman saya dan merekod pemulangan supaya
   rekod pinjaman sentiasa kemas kini.

---

## 3. Keperluan Fungsi

### KF-1 Pendaftaran Pengguna

- Borang: **Nama**, **No. IC**, **Jawatan**, **Bahagian** — semua wajib.
- Pengesahan: medan kosong → mesej ralat merah; No. IC mesti 12 digit angka.
- Selepas berjaya: pengguna disimpan sebagai pengguna aktif sesi, navigasi ke Senarai Buku.

### KF-2 Senarai Buku

- Kad menunjukkan **Tajuk Buku**, **SSDN**, **Penerbit**, **Bilangan salinan tersedia**.
- Carian mengikut tajuk buku.
- Buku dengan salinan tersedia = 0 dipaparkan sebagai **Tiada Stok**; butang Pinjam dinyahaktifkan.

### KF-3 Peminjaman Buku

- **Tarikh Pinjam** = tarikh semasa. **Tarikh Akhir Pinjam** = Tarikh Pinjam + 14 hari.
- Sekatan pertindihan: ditolak jika salinan tersedia = 0, atau pengguna aktif sudah mempunyai
  pinjaman aktif bagi buku yang sama.
- Selepas berjaya: salinan tersedia −1, rekod pinjaman berstatus **Aktif**.
- **Pembaharuan:** butang **Baharui** menambah 14 hari pada Tarikh Akhir Pinjam dan menetapkan
  `isRenewed = true`. Hanya sekali bagi setiap pinjaman.

### KF-4 Pemulangan Buku

- Merekod **Tarikh Pulang Sebenar** = tarikh semasa.
- Selepas berjaya: salinan tersedia +1, status pinjaman → **Dipulangkan**.

### KF-5 Senarai Pinjaman Buku

- Senarai: **Tajuk Buku**, **Tarikh Pinjam**, **Tarikh Akhir Pinjam**, **Tarikh Pulang Sebenar**.
- Penapis: **Aktif** / **Dipulangkan** / **Semua**.
- Status: **Aktif**, **Lewat** (melepasi tarikh akhir dan belum dipulangkan), **Dipulangkan**.

---

## 4. Skrin & Navigasi

| # | Skrin | Fail | Navigasi keluar |
|---|-------|------|-----------------|
| 1 | Pendaftaran Pengguna | `registration_screen.dart` | Hantar → Senarai Buku (`pushReplacement`) |
| 2 | Senarai Buku | `book_list_screen.dart` | Pinjam → Peminjaman · Ikon senarai → Senarai Pinjaman |
| 3 | Peminjaman Buku | `borrow_screen.dart` | Sahkan → kembali ke Senarai Buku + SnackBar |
| 4 | Senarai Pinjaman Buku | `loan_list_screen.dart` | Pulang → Pemulangan |
| 5 | Pemulangan Buku | `return_screen.dart` | Sahkan → kembali ke Senarai Pinjaman + SnackBar |

Aliran: **Pendaftaran → Senarai Buku → Peminjaman → Senarai Pinjaman → Pemulangan**

---

## 5. Model Data

```dart
class User   { String id; String name; String icNumber; String position; String department; }
class Book   { String id; String title; String ssdn; String publisher;
               int totalCopies; int availableCopies; }
class Loan   { String id; String userId; String bookId; String bookTitle;
               DateTime borrowDate; DateTime dueDate; DateTime? returnDate; bool isRenewed; }
enum LoanStatus { active, overdue, returned }   // dikira, bukan disimpan
```

---

## 6. Seni Bina

```
lib/
├── main.dart
├── models/      user.dart · book.dart · loan.dart
├── data/        sample_books.dart · app_repository.dart
├── services/    loan_service.dart · date_formatter.dart
├── widgets/     app_text_field.dart · book_card.dart · loan_card.dart · status_chip.dart
├── screens/     registration_screen.dart · book_list_screen.dart · borrow_screen.dart
│                loan_list_screen.dart · return_screen.dart
└── theme/       app_theme.dart
```

State: setiap skrin ialah `StatefulWidget` yang membaca/menulis ke `AppRepository` (singleton)
dan memanggil `setState()` selepas setiap operasi. Tiada provider/Bloc.

---

## 7. Kriteria Penerimaan (Definition of Done)

**Pendaftaran**

- [x] Menekan **Hantar** dengan medan kosong memaparkan ralat merah; skrin tidak bertukar.
- [x] No. IC bukan 12 digit → "No. IC mesti 12 digit angka"; skrin tidak bertukar.
- [x] Semua medan sah → Senarai Buku dipaparkan, nama pengguna kelihatan pada AppBar.

**Senarai Buku**

- [x] Sekurang-kurangnya 8 buku dipaparkan dengan tajuk, SSDN, penerbit dan "Tersedia: X".
- [x] Carian menapis senarai secara langsung.
- [x] "Tersedia: 0" → label **Tiada Stok**, butang **Pinjam** dinyahaktifkan.

**Peminjaman**

- [x] Tarikh Pinjam = hari ini, Tarikh Akhir = +14 hari, format `dd/MM/yyyy`.
- [x] **Sahkan Pinjaman** → SnackBar "Pinjaman berjaya"; "Tersedia" berkurang 1.
- [x] Pinjam buku sama sekali lagi → dialog "Anda sudah meminjam buku ini"; tiada rekod baharu.

**Pembaharuan**

- [x] **Baharui** menambah 14 hari pada Tarikh Akhir Pinjam.
- [x] Selepas dibaharui, butang hilang dan label "Telah Dibaharui" dipaparkan.

**Pemulangan**

- [x] **Sahkan Pemulangan** → SnackBar "Pemulangan berjaya"; pinjaman berpindah ke **Dipulangkan**.
- [x] "Tersedia" bagi buku itu bertambah 1.

**Senarai Pinjaman**

- [x] Kad memaparkan tajuk, Tarikh Pinjam, Tarikh Akhir, Tarikh Pulang (atau "—").
- [x] Penapis **Aktif** hanya memaparkan pinjaman belum dipulangkan.
- [x] Pinjaman melepasi tarikh akhir memaparkan chip merah **Lewat**.

**Umum**

- [x] Teks UI Bahasa Melayu; pengecam kod Bahasa Inggeris.
- [x] Warna/gaya dari satu `ThemeData` dalam `app_theme.dart`.
- [x] `flutter analyze` tiada ralat.

---

## 8. Susunan Pembinaan

| Langkah | Hasil |
|---------|-------|
| 1 | Asas & tema, model, data contoh, repositori |
| 2 | Skrin Pendaftaran + pengesahan |
| 3 | Senarai Buku + carian |
| 4 | Peminjaman + sekatan pertindihan |
| 5 | Senarai Pinjaman + Pembaharuan |
| 6 | Pemulangan + status Lewat + kemasan |

---

## Cadangan (pilihan) — di luar skop

- Peringatan tempatan 2 hari sebelum tarikh akhir (`flutter_local_notifications`).
- Penyimpanan kekal (`shared_preferences`).
- Skrin pentadbir untuk menambah buku.
- Migrasi ke API sebenar (`http` + JSON, `services/api_service.dart`).
