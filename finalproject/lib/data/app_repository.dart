import '../models/book.dart';
import '../models/loan.dart';
import '../models/user.dart';
import 'sample_books.dart';

/// Simpanan dalam ingatan untuk satu sesi aplikasi.
/// Data akan hilang apabila aplikasi ditutup.
class AppRepository {
  AppRepository._();

  static final AppRepository instance = AppRepository._();

  final List<Book> books = buildSampleBooks();
  final List<Loan> loans = [];

  User? currentUser;

  int _loanCounter = 0;

  String nextLoanId() {
    _loanCounter++;
    return 'L${_loanCounter.toString().padLeft(3, '0')}';
  }

  Book bookById(String id) => books.firstWhere((book) => book.id == id);

  List<Book> searchBooks(String keyword) {
    final query = keyword.trim().toLowerCase();
    if (query.isEmpty) return List.unmodifiable(books);
    return books.where((book) => book.title.toLowerCase().contains(query)).toList();
  }

  /// Pinjaman milik pengguna aktif, terbaharu di atas.
  List<Loan> loansForCurrentUser() {
    final userId = currentUser?.id;
    if (userId == null) return const [];
    return loans.where((loan) => loan.userId == userId).toList().reversed.toList();
  }

  bool hasActiveLoanFor(String bookId) {
    final userId = currentUser?.id;
    if (userId == null) return false;
    return loans.any(
      (loan) => loan.userId == userId && loan.bookId == bookId && !loan.isReturned,
    );
  }
}
