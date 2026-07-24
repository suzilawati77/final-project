/// Pemformatan tarikh ringkas (tanpa pakej luaran).
class DateFormatter {
  const DateFormatter._();

  /// Contoh: 24/07/2026
  static String format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// "—" apabila tarikh belum wujud.
  static String formatOrDash(DateTime? date) => date == null ? '—' : format(date);

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Bilangan hari lewat berbanding tarikh akhir (0 jika belum lewat).
  static int daysOverdue(DateTime dueDate, DateTime now) {
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final current = DateTime(now.year, now.month, now.day);
    final difference = current.difference(due).inDays;
    return difference > 0 ? difference : 0;
  }
}
