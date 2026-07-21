// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/data/sample_programmes.dart
// 8 tawaran pengajian eTT contoh (sampleProgrammes).
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════

import '../../models/programme.dart';

/// Data contoh 8 tawaran pengajian eTT (Mesir & Maghribi).
///
/// Digunakan sebelum sambungan REST API (SESI 6) dan sebagai data sandaran
/// (fallback) apabila API tidak dapat dicapai.
///
/// NOTA PENTING TENTANG DATA:
/// * Nama universiti & syarat asas adalah **benar** (rujukan: Syarat_Mesir,
///   portal dohe.mohe.gov.my/timurtengah).
/// * `estimatedAnnualCostMyr` adalah **ilustrasi anggaran** (diselaras dengan
///   jadual USD rasmi 2021/22) — bukan sebut harga rasmi.
/// * `quotaSeats` adalah **ilustrasi**, KECUALI laluan Maghribi (15 tempat)
///   yang merupakan angka rasmi.
/// * Pemadanan bidang Maghribi (Mohammed V) adalah ilustrasi latihan —
///   penempatan sebenar ditentukan kerajaan Maghribi.
final List<Programme> sampleProgrammes = [
  Programme(
    id: 'ETT-001',
    universityName: 'Universiti Al-Azhar',
    country: 'Egypt',
    city: 'Kaherah (Cairo)',
    fieldOfStudy: 'Perubatan (Medicine)',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 23000,
    intakeMonth: 'September',
    recognitionNote:
        'Semak pengiktirafan di www2.mqa.gov.my/esisraf (eSisraf, MQA); perubatan tertakluk '
        'syarat Majlis Perubatan Malaysia (MMC). Kos anggaran ilustrasi.',
    quotaSeats: 40,
  ),
  Programme(
    id: 'ETT-002',
    universityName: 'Universiti Al-Azhar',
    country: 'Egypt',
    city: 'Kaherah (Cairo)',
    fieldOfStudy: 'Syariah dan Undang-undang',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.stam,
    estimatedAnnualCostMyr: 5000,
    intakeMonth: 'September',
    recognitionNote:
        'Laluan STAM (minimum Jayyid) & lulus Tahap Mutamayiz Bahasa Arab. '
        'Kos ilustrasi.',
    quotaSeats: 120,
  ),
  Programme(
    id: 'ETT-003',
    universityName: 'Universiti Al-Azhar',
    country: 'Egypt',
    city: 'Kaherah (Cairo)',
    fieldOfStudy: 'Ulum Islamiah',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 4500,
    intakeMonth: 'September',
    recognitionNote:
        'Laluan SPM dengan Bahasa Arab & subjek Pengajian Islam. Kos ilustrasi.',
    quotaSeats: 80,
  ),
  Programme(
    id: 'ETT-004',
    universityName: 'Universiti Alexandria',
    country: 'Egypt',
    city: 'Iskandariah (Alexandria)',
    fieldOfStudy: 'Farmasi (Pharmacy)',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 36000,
    intakeMonth: 'September',
    recognitionNote:
        'Semak pengiktirafan program di www2.mqa.gov.my/esisraf (eSisraf, MQA). Kos ilustrasi.',
    quotaSeats: 30,
  ),
  Programme(
    id: 'ETT-005',
    universityName: 'Universiti Ain Shams',
    country: 'Egypt',
    city: 'Kaherah (Cairo)',
    fieldOfStudy: 'Perubatan (Medicine)',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 34000,
    intakeMonth: 'September',
    recognitionNote:
        'Memerlukan SPM & sijil matrikulasi/asasi/STPM/A-Level diiktiraf MMC. '
        'Kos ilustrasi.',
    quotaSeats: 25,
  ),
  Programme(
    id: 'ETT-006',
    universityName: 'Universiti Tanta',
    country: 'Egypt',
    city: 'Tanta',
    fieldOfStudy: 'Pergigian (Dentistry)',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 27000,
    intakeMonth: 'September',
    recognitionNote:
        'Semak pengiktirafan program di www2.mqa.gov.my/esisraf (eSisraf, MQA). Kos ilustrasi.',
    quotaSeats: 20,
  ),
  Programme(
    id: 'ETT-007',
    universityName: 'Universite Al Quaraouiyine',
    country: 'Morocco',
    city: 'Fes',
    fieldOfStudy: 'Usuluddin',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.both,
    estimatedAnnualCostMyr: 6000,
    intakeMonth: 'October',
    recognitionNote:
        'Universiti tertua di dunia (859M). Penempatan Maghribi ditentukan '
        'kerajaan Maghribi; kos ilustrasi.',
    quotaSeats: 15,
  ),
  Programme(
    id: 'ETT-008',
    universityName: 'Universiti Mohammed V',
    country: 'Morocco',
    city: 'Rabat',
    fieldOfStudy: 'Bahasa Arab (Arabic Language)',
    studyLevel: StudyLevel.bachelor,
    category: EntryCategory.spm,
    estimatedAnnualCostMyr: 7000,
    intakeMonth: 'October',
    recognitionNote:
        'Universiti sebenar; pemadanan bidang ilustrasi latihan — penempatan '
        'sebenar ditentukan kerajaan Maghribi. Kos ilustrasi.',
    quotaSeats: 10,
  ),
];