// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/models/application.dart
// Model Application + enum ApplicationStatus (untuk borang).
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'programme.dart';

/// Status kitaran hayat permohonan eTT.
///
/// Menggunakan istilah sebenar eTT: **LAYAK / TIDAK LAYAK** disemak ~7 hari
/// bekerja selepas permohonan ditutup.
///
/// NOTA (untuk kelas): dalam sistem sebenar, terdapat peringkat muat naik
/// dokumen sokongan + bayaran pemprosesan **antara** status LAYAK dan surat
/// tawaran. Status "diterima/ditolak" di sini adalah penyederhanaan model.
enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  eligible,
  notEligible,
  offered,
  accepted,
  rejected;

  /// Label Bahasa Melayu untuk paparan UI.
  String get label => switch (this) {
        ApplicationStatus.draft => 'Draf',
        ApplicationStatus.submitted => 'Dihantar',
        ApplicationStatus.underReview => 'Dalam Semakan',
        ApplicationStatus.eligible => 'Layak',
        ApplicationStatus.notEligible => 'Tidak Layak',
        ApplicationStatus.offered => 'Tawaran',
        ApplicationStatus.accepted => 'Diterima',
        ApplicationStatus.rejected => 'Ditolak',
      };

  /// Warna badge status untuk paparan UI.
  Color get color => switch (this) {
        ApplicationStatus.draft => Colors.grey,
        ApplicationStatus.submitted => Colors.blue,
        ApplicationStatus.underReview => Colors.orange,
        ApplicationStatus.eligible => Colors.teal,
        ApplicationStatus.notEligible => Colors.red,
        ApplicationStatus.offered => Colors.indigo,
        ApplicationStatus.accepted => Colors.green,
        ApplicationStatus.rejected => Colors.red,
      };

  static ApplicationStatus fromString(String value) {
    return ApplicationStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ApplicationStatus.draft,
    );
  }
}

/// Satu permohonan pelajar menerusi eTT (dicipta dalam aplikasi).
///
/// **Peraturan sebenar eTT:** SATU negara + SATU bidang setiap permohonan.
/// Dalam bidang itu, pelajar boleh menyusun sehingga **3 pilihan universiti**.
class Application {
  final String id;
  final String fullName;
  final String icNumber;
  final String email;
  final String phoneNumber;

  /// Kategori sijil yang dipegang pemohon (SPM atau STAM).
  final EntryCategory academicCategory;

  /// Ringkasan akademik ringkas, cth: "SPM 2025 — 9A" (teks bebas ilustrasi).
  final String academicSummary;

  /// 1 negara (peraturan sebenar eTT).
  final String country;

  /// 1 bidang (peraturan sebenar eTT).
  final String fieldOfStudy;

  /// 1–3 id Programme (pilihan universiti dalam bidang tersebut).
  final List<String> universityChoiceIds;

  /// Label dokumen yang dimuat naik (peringkat LAYAK).
  final List<String> uploadedDocuments;

  final ApplicationStatus status;
  final DateTime? submittedAt;

  const Application({
    required this.id,
    required this.fullName,
    required this.icNumber,
    required this.email,
    required this.phoneNumber,
    required this.academicCategory,
    required this.academicSummary,
    required this.country,
    required this.fieldOfStudy,
    required this.universityChoiceIds,
    this.uploadedDocuments = const [],
    this.status = ApplicationStatus.submitted,
    this.submittedAt,
  });

  /// Salin dengan sebahagian medan ditukar (corak immutable).
  Application copyWith({
    ApplicationStatus? status,
    List<String>? uploadedDocuments,
  }) {
    return Application(
      id: id,
      fullName: fullName,
      icNumber: icNumber,
      email: email,
      phoneNumber: phoneNumber,
      academicCategory: academicCategory,
      academicSummary: academicSummary,
      country: country,
      fieldOfStudy: fieldOfStudy,
      universityChoiceIds: universityChoiceIds,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      status: status ?? this.status,
      submittedAt: submittedAt,
    );
  }

  /// Nama negara dalam Bahasa Melayu untuk paparan UI.
  String get countryLabel => switch (country) {
        'Egypt' => 'Mesir',
        'Morocco' => 'Maghribi',
        _ => country,
      };

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      icNumber: json['icNumber'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      academicCategory:
          EntryCategory.fromString(json['academicCategory'] as String),
      academicSummary: json['academicSummary'] as String,
      country: json['country'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      universityChoiceIds:
          (json['universityChoiceIds'] as List).cast<String>(),
      uploadedDocuments:
          (json['uploadedDocuments'] as List?)?.cast<String>() ?? const [],
      status: ApplicationStatus.fromString(json['status'] as String),
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'icNumber': icNumber,
        'email': email,
        'phoneNumber': phoneNumber,
        'academicCategory': academicCategory.name,
        'academicSummary': academicSummary,
        'country': country,
        'fieldOfStudy': fieldOfStudy,
        'universityChoiceIds': universityChoiceIds,
        'uploadedDocuments': uploadedDocuments,
        'status': status.name,
        'submittedAt': submittedAt?.toIso8601String(),
      };
}