// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/models/programme.dart
// Model data Programme + enum StudyLevel & EntryCategory.
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════

/// Model utama: satu tawaran pengajian (universiti + bidang) menerusi sistem
/// e-Timur Tengah (eTT) — Mesir atau Maghribi (Morocco).
///
/// eTT ialah sistem Bahagian Pengantarabangsaan Pendidikan Tinggi (BPPT), JPT,
/// KPT. Pelajar meneliti tawaran ini sebelum membuat permohonan.
library;

/// Peringkat pengajian yang ditawarkan.
enum StudyLevel {
  foundation,
  diploma,
  bachelor;

  /// Label Bahasa Melayu untuk paparan UI.
  String get label => switch (this) {
        StudyLevel.foundation => 'Asasi',
        StudyLevel.diploma => 'Diploma',
        StudyLevel.bachelor => 'Ijazah Sarjana Muda',
      };

  static StudyLevel fromString(String value) {
    return StudyLevel.values.firstWhere(
      (s) => s.name == value,
      orElse: () => StudyLevel.bachelor,
    );
  }
}

/// Kategori kemasukan — sijil yang boleh memohon tawaran ini.
///
/// eTT terbuka kepada lepasan **SPM** & **STAM**. Sesetengah bidang menerima
/// kedua-dua kategori.
enum EntryCategory {
  spm,
  stam,
  both;

  /// Label Bahasa Melayu untuk paparan UI.
  String get label => switch (this) {
        EntryCategory.spm => 'SPM',
        EntryCategory.stam => 'STAM',
        EntryCategory.both => 'SPM atau STAM',
      };

  /// Adakah kategori sijil pemohon [applicant] layak untuk tawaran ini?
  bool accepts(EntryCategory applicant) =>
      this == EntryCategory.both || this == applicant;

  static EntryCategory fromString(String value) {
    return EntryCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => EntryCategory.spm,
    );
  }
}

/// Satu tawaran pengajian (universiti + bidang) menerusi eTT.
class Programme {
  final String id;
  final String universityName;

  /// "Egypt" atau "Morocco".
  final String country;
  final String city;

  /// Bidang pengajian, cth: "Perubatan (Medicine)".
  final String fieldOfStudy;

  final StudyLevel studyLevel;

  /// Kategori sijil yang layak memohon (SPM / STAM / kedua-duanya).
  final EntryCategory category;

  /// Anggaran yuran tahunan dalam Ringgit Malaysia.
  ///
  /// **ILUSTRASI SAHAJA** — diselaras dengan jadual USD rasmi 2021/22 untuk
  /// tujuan latihan. Bukan sebut harga rasmi.
  final double estimatedAnnualCostMyr;

  /// Bulan pengambilan, cth: "September".
  final String intakeMonth;

  /// Nota pengiktirafan/syarat — membawa kaveat "kos ilustrasi".
  final String recognitionNote;

  /// Bilangan tempat.
  ///
  /// **ILUSTRASI SAHAJA**, kecuali laluan Maghribi (15 tempat) yang merupakan
  /// angka rasmi.
  final int quotaSeats;

  const Programme({
    required this.id,
    required this.universityName,
    required this.country,
    required this.city,
    required this.fieldOfStudy,
    required this.studyLevel,
    required this.category,
    required this.estimatedAnnualCostMyr,
    required this.intakeMonth,
    required this.recognitionNote,
    required this.quotaSeats,
  });

  /// Emoji bendera negara — nilai terbitan (derived), tiada dalam JSON.
  String get flagEmoji => switch (country) {
        'Egypt' => '🇪🇬',
        'Morocco' => '🇲🇦',
        _ => '🌍',
      };

  /// Nama negara dalam Bahasa Melayu untuk paparan UI.
  String get countryLabel => switch (country) {
        'Egypt' => 'Mesir',
        'Morocco' => 'Maghribi',
        _ => country,
      };

  /// Bina objek daripada JSON (guna bila sambung REST API — SESI 6 & 7).
  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['id'] as String,
      universityName: json['universityName'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      studyLevel: StudyLevel.fromString(json['studyLevel'] as String),
      category: EntryCategory.fromString(json['category'] as String),
      estimatedAnnualCostMyr:
          (json['estimatedAnnualCostMyr'] as num).toDouble(),
      intakeMonth: json['intakeMonth'] as String,
      recognitionNote: json['recognitionNote'] as String,
      quotaSeats: json['quotaSeats'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'universityName': universityName,
        'country': country,
        'city': city,
        'fieldOfStudy': fieldOfStudy,
        'studyLevel': studyLevel.name,
        'category': category.name,
        'estimatedAnnualCostMyr': estimatedAnnualCostMyr,
        'intakeMonth': intakeMonth,
        'recognitionNote': recognitionNote,
        'quotaSeats': quotaSeats,
      };
}