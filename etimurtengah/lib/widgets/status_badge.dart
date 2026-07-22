// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/widgets/status_badge.dart
// Cip berwarna kecil yang memaparkan status permohonan (Layak/Tidak Layak…).
// Guna dalam skrin "Permohonan Saya".
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../models/application.dart';

/// Cip berwarna kecil yang memaparkan status permohonan.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color, width: 1),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}