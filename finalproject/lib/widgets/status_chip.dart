import 'package:flutter/material.dart';

import '../models/loan.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final LoanStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    switch (status) {
      case LoanStatus.active:
        color = AppTheme.statusActive;
        label = 'Aktif';
      case LoanStatus.overdue:
        color = AppTheme.statusOverdue;
        label = 'Lewat';
      case LoanStatus.returned:
        color = AppTheme.statusReturned;
        label = 'Dipulangkan';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
