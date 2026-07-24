import '../data/app_repository.dart';
import '../models/book.dart';
import '../models/loan.dart';
import 'date_formatter.dart';

/// Sebab kegagalan operasi pinjaman.
enum LoanFailure { noUser, outOfStock, duplicateLoan, alreadyRenewed, alreadyReturned }

class LoanResult {
  final bool success;
  final LoanFailure? failure;
  final Loan? loan;

  const LoanResult.success(this.loan)
      : success = true,
        failure = null;

  const LoanResult.failed(this.failure)
      : success = false,
        loan = null;

  String get message {
    switch (failure) {
      case LoanFailure.noUser:
        return 'Sila daftar pengguna terlebih dahulu.';
      case LoanFailure.outOfStock:
        return 'Buku ini tiada stok pada masa ini.';
      case LoanFailure.duplicateLoan:
        return 'Anda sudah meminjam buku ini.';
      case LoanFailure.alreadyRenewed:
        return 'Pinjaman ini telah dibaharui sekali dan tidak boleh dibaharui lagi.';
      case LoanFailure.alreadyReturned:
        return 'Pinjaman ini telah pun dipulangkan.';
      case null:
        return 'Berjaya.';
    }
  }
}

class LoanService {
  LoanService._();

  static final LoanService instance = LoanService._();

  static const int loanPeriodInDays = 14;
  static const int renewalPeriodInDays = 14;

  final AppRepository _repository = AppRepository.instance;

  DateTime dueDateFor(DateTime borrowDate) =>
      borrowDate.add(const Duration(days: loanPeriodInDays));

  /// Menyekat pertindihan: stok habis atau pengguna sudah meminjam buku yang sama.
  LoanFailure? validateBorrow(Book book) {
    if (_repository.currentUser == null) return LoanFailure.noUser;
    if (!book.isAvailable) return LoanFailure.outOfStock;
    if (_repository.hasActiveLoanFor(book.id)) return LoanFailure.duplicateLoan;
    return null;
  }

  LoanResult borrow(Book book) {
    final failure = validateBorrow(book);
    if (failure != null) return LoanResult.failed(failure);

    final borrowDate = DateFormatter.today();
    final loan = Loan(
      id: _repository.nextLoanId(),
      userId: _repository.currentUser!.id,
      bookId: book.id,
      bookTitle: book.title,
      borrowDate: borrowDate,
      dueDate: dueDateFor(borrowDate),
    );

    book.availableCopies--;
    _repository.loans.add(loan);
    return LoanResult.success(loan);
  }

  LoanResult renew(Loan loan) {
    if (loan.isReturned) return const LoanResult.failed(LoanFailure.alreadyReturned);
    if (loan.isRenewed) return const LoanResult.failed(LoanFailure.alreadyRenewed);

    loan.dueDate = loan.dueDate.add(const Duration(days: renewalPeriodInDays));
    loan.isRenewed = true;
    return LoanResult.success(loan);
  }

  LoanResult returnBook(Loan loan) {
    if (loan.isReturned) return const LoanResult.failed(LoanFailure.alreadyReturned);

    loan.returnDate = DateFormatter.today();
    _repository.bookById(loan.bookId).availableCopies++;
    return LoanResult.success(loan);
  }
}
