// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/widgets/programme_card.dart
// Kad ringkasan satu tawaran + CategoryPill (cip kategori SPM/STAM).
// Lab Hari 2 GUNA SEMULA `CategoryPill` dari fail ini — jadi salin dulu.
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../models/programme.dart';
import '../theme.dart';

// Format ringkas RM tanpa pakej luar (cth. 12345 -> "RM12,345"), supaya
// fail starter ini terus berfungsi dalam projek `flutter create` baharu.
// (Aplikasi rujukan `projek/ett_mobile` guna `NumberFormat` dari pakej intl.)
String _formatRm(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer('RM');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Kad ringkasan satu tawaran pengajian dalam senarai.
///
/// Struktur: Row [ bendera | Expanded(Column: universiti + bidang) | kos RM ].
class ProgrammeCard extends StatelessWidget {
  const ProgrammeCard({
    super.key,
    required this.programme,
    this.onTap,
  });

  final Programme programme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programme.flagEmoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          programme.universityName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: KptTheme.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          programme.fieldOfStudy,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${programme.city}, ${programme.countryLabel}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Anggaran kos tahunan dalam RM (ilustrasi).
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatRm(programme.estimatedAnnualCostMyr),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KptTheme.navy,
                        ),
                      ),
                      Text(
                        '/tahun',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CategoryPill(category: programme.category),
                  const SizedBox(width: 8),
                  _Pill(text: programme.countryLabel, color: KptTheme.navy),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cip kategori kemasukan (SPM / STAM / kedua-duanya).
class CategoryPill extends StatelessWidget {
  const CategoryPill({super.key, required this.category});

  final EntryCategory category;

  @override
  Widget build(BuildContext context) {
    return _Pill(text: category.label, color: KptTheme.gold);
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}