import 'package:flutter/material.dart';

import '../data/app_repository.dart';
import '../models/book.dart';
import '../services/loan_service.dart';
import '../widgets/book_card.dart';
import 'borrow_screen.dart';
import 'loan_list_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final AppRepository _repository = AppRepository.instance;
  final TextEditingController _searchController = TextEditingController();

  String _keyword = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openBorrow(Book book) async {
    final failure = LoanService.instance.validateBorrow(book);
    if (failure != null) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pinjaman Tidak Dibenarkan'),
          content: Text(LoanResult.failed(failure).message),
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

    final borrowed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => BorrowScreen(book: book)),
    );
    if (!mounted) return;
    if (borrowed == true) {
      setState(() {});
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Pinjaman berjaya')));
    }
  }

  Future<void> _openLoanList() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const LoanListScreen()),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _repository.currentUser;
    final books = _repository.searchBooks(_keyword);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Senarai Buku'),
        actions: [
          IconButton(
            onPressed: _openLoanList,
            icon: const Icon(Icons.list_alt),
            tooltip: 'Senarai Pinjaman',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user == null ? '' : '${user.name} • ${user.department}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari tajuk buku',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _keyword = value),
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? const Center(
                    child: Text(
                      'Tiada buku ditemui.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return BookCard(
                        book: book,
                        onBorrow: () => _openBorrow(book),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
