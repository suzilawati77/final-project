import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/date_formatter.dart';
import '../services/loan_service.dart';

class BorrowScreen extends StatefulWidget {
  final Book book;

  const BorrowScreen({super.key, required this.book});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  late final DateTime _borrowDate = DateFormatter.today();
  late final DateTime _dueDate = LoanService.instance.dueDateFor(_borrowDate);

  void _confirm() {
    final result = LoanService.instance.borrow(widget.book);
    if (!result.success) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pinjaman Gagal'),
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
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(title: const Text('Peminjaman Buku')),
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
                      book.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'SSDN', value: book.ssdn),
                    _InfoRow(label: 'Penerbit', value: book.publisher),
                    _InfoRow(label: 'Salinan Tersedia', value: '${book.availableCopies}'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Maklumat Pinjaman',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Tarikh Pinjam', value: DateFormatter.format(_borrowDate)),
                    _InfoRow(
                      label: 'Tarikh Akhir Pinjam',
                      value: DateFormatter.format(_dueDate),
                    ),
                    _InfoRow(label: 'Status Renewal', value: 'Belum dibaharui'),
                    const SizedBox(height: 8),
                    Text(
                      'Tempoh pinjaman ${LoanService.loanPeriodInDays} hari. '
                      'Pembaharuan dibenarkan sekali sahaja.',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: FilledButton(
                onPressed: _confirm,
                child: const Text('Sahkan Pinjaman'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(': $value', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
