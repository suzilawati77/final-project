import 'package:flutter/material.dart';

import '../models/loan.dart';
import '../services/date_formatter.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final VoidCallback onRenew;
  final VoidCallback onReturn;

  const LoanCard({
    super.key,
    required this.loan,
    required this.onRenew,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final status = loan.statusAt(DateTime.now());
    final canRenew = !loan.isReturned && !loan.isRenewed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    loan.bookTitle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 10),
            _DetailRow(label: 'Tarikh Pinjam', value: DateFormatter.format(loan.borrowDate)),
            _DetailRow(label: 'Tarikh Akhir Pinjam', value: DateFormatter.format(loan.dueDate)),
            _DetailRow(
              label: 'Tarikh Pulang',
              value: DateFormatter.formatOrDash(loan.returnDate),
            ),
            if (status == LoanStatus.overdue)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Lewat ${DateFormatter.daysOverdue(loan.dueDate, DateTime.now())} hari',
                  style: const TextStyle(
                    color: AppTheme.statusOverdue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (loan.isRenewed)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Telah Dibaharui',
                  style: TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.w600),
                ),
              ),
            if (!loan.isReturned) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (canRenew) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRenew,
                        child: const Text('Baharui'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: onReturn,
                      child: const Text('Pulang'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Text(': $value', style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
