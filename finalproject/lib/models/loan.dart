enum LoanStatus { active, overdue, returned }

class Loan {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  bool isRenewed;

  Loan({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isRenewed = false,
  });

  bool get isReturned => returnDate != null;

  LoanStatus statusAt(DateTime now) {
    if (isReturned) return LoanStatus.returned;
    final endOfDueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);
    return now.isAfter(endOfDueDate) ? LoanStatus.overdue : LoanStatus.active;
  }
}
