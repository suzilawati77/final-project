import 'package:flutter/material.dart';

import '../models/loan.dart';
import '../services/date_formatter.dart';
import '../services/loan_service.dart';

class ReturnScreen extends StatefulWidget {
  final Loan loan;

  const ReturnScreen({super.key, required this.loan});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  late final DateTime _returnDate = DateFormatter.today();

  void _confirm() {
    final result = LoanService.instance.returnBook(widget.loan);
    if (!result.success) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pemulangan Gagal'),
          content: Text(result.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;
    final overdueDays = DateFormatter.daysOverdue(loan.dueDate, _returnDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Pemulangan Buku')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.bookTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Tarikh Pinjam',
                      value: DateFormatter.format(loan.borrowDate),
                    ),
                    _InfoRow(
                      label: 'Tarikh Akhir Pinjam',
                      value: DateFormatter.format(loan.dueDate),
                    ),
                    _InfoRow(
                      label: 'Tarikh Pulang Sebenar',
                      value: DateFormatter.format(_returnDate),
                    ),
                    if (overdueDays > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Pemulangan lewat $overdueDays hari.',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: FilledButton(
                onPressed: _confirm,
                child: const Text('Sahkan Pemulangan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Text(': $value', style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
