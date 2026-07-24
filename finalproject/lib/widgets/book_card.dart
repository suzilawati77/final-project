import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/app_theme.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onBorrow;

  const BookCard({super.key, required this.book, required this.onBorrow});

  @override
  Widget build(BuildContext context) {
    final available = book.isAvailable;

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
                    book.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                if (!available)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.statusOverdue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.statusOverdue),
                    ),
                    child: const Text(
                      'Tiada Stok',
                      style: TextStyle(
                        color: AppTheme.statusOverdue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('SSDN: ${book.ssdn}', style: const TextStyle(color: Colors.black54)),
            Text('Penerbit: ${book.publisher}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 4),
            Text(
              'Tersedia: ${book.availableCopies} / ${book.totalCopies}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: available ? AppTheme.statusActive : AppTheme.statusOverdue,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: available ? onBorrow : null,
                child: const Text('Pinjam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
