// ============================================================================
// validators.dart — Lab Hari 3: Kawalan Borang & State Management Asas
//
// Fungsi validator TULEN Dart (pure Dart) untuk Borang Permohonan eTT
// (rujuk lib/models/application.dart & lib/screens/application_form_screen.dart
// dalam projek/ett_mobile).
//
// Sengaja TIDAK mengimport package:flutter — setiap fungsi hanya menerima
// String? dan memulangkan String? (mesej ralat, atau null jika sah). Ini
// bermakna fail ini:
//   1. Boleh diuji terus dengan `dart test` / `dart analyze` tanpa Flutter SDK.
//   2. Sepadan terus dengan tandatangan `FormFieldValidator<String>` yang
//      diperlukan oleh parameter `validator:` pada TextFormField — cukup
//      hantar rujukan fungsi terus, cth: `validator: validateIcNumber`.
//
// Latihan Slot AI (SESI 5) — lihat hari-3/README.md Bahagian 8 — meminta
// AI menjana versi PERTAMA fungsi-fungsi ini, kemudian kod di bawah adalah
// versi yang telah DISEMAK SEMULA secara kritikal (ujian kes tepi, format
// mesej Bahasa Melayu, dan lulus `dart analyze` tanpa amaran).
// ============================================================================

/// Validator generik untuk medan wajib diisi.
///
/// [fieldLabel] ialah nama medan (Bahasa Melayu) yang dipaparkan dalam
/// mesej ralat, cth: `validateRequired(value, 'Nama Penuh')` ->
/// "Nama Penuh diperlukan" jika kosong.
String? validateRequired(String? value, String fieldLabel) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldLabel diperlukan';
  }
  return null;
}

/// Mengesahkan No. Kad Pengenalan Malaysia — medan `icNumber` pada
/// `Application` (permohonan eTT tidak memerlukan No. Pasport dalam
/// borang; pasport hanya diperlukan kelak semasa urusan kelayakan sebenar).
///
/// Peraturan (untuk latihan ini — bukan semakan digit semak rasmi JPN):
///   - Wajib diisi.
///   - Selepas membuang sengkang (`-`), mesti mengandungi TEPAT 12 digit.
///   - Hanya digit (dan sengkang pilihan) dibenarkan.
///
/// Menerima kedua-dua format `051231145678` dan `051231-14-5678`.
String? validateIcNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'No. Kad Pengenalan diperlukan';
  }
  final trimmed = value.trim();
  if (!RegExp(r'^[0-9-]+$').hasMatch(trimmed)) {
    return 'No. Kad Pengenalan hanya boleh mengandungi digit dan sengkang (-)';
  }
  final digits = trimmed.replaceAll('-', '');
  if (digits.length != 12) {
    return 'No. Kad Pengenalan mesti 12 digit (cth: 051231-14-5678)';
  }
  return null;
}

/// Mengesahkan format alamat emel secara ringkas (bukan RFC 5322 penuh —
/// mencukupi untuk borang latihan; pengesahan sebenar berlaku di pelayan).
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Emel diperlukan';
  }
  final trimmed = value.trim();
  final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  if (!regex.hasMatch(trimmed)) {
    return 'Format emel tidak sah';
  }
  return null;
}

/// Mengesahkan nombor telefon (Malaysia atau antarabangsa).
///
/// Membuang ruang dan sengkang dahulu, kemudian menerima 9–15 digit dengan
/// awalan `+` pilihan (cth: `0123456789`, `012-345 6789`, `+60123456789`).
String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'No. Telefon diperlukan';
  }
  final digits = value.trim().replaceAll(RegExp(r'[\s-]'), '');
  if (!RegExp(r'^\+?\d{9,15}$').hasMatch(digits)) {
    return 'No. Telefon tidak sah (cth: 0123456789)';
  }
  return null;
}