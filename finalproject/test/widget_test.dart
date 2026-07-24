import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kpt_book_loan/data/app_repository.dart';
import 'package:kpt_book_loan/main.dart';

Future<void> _register(WidgetTester tester) async {
  await tester.pumpWidget(const KptBookLoanApp());

  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), 'Ahmad bin Ali');
  await tester.enterText(fields.at(1), '900101015555');
  await tester.enterText(fields.at(2), 'Pegawai Teknologi Maklumat');
  await tester.enterText(fields.at(3), 'Bahagian Pengurusan Maklumat');
  await tester.tap(find.widgetWithText(FilledButton, 'Hantar'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    final repository = AppRepository.instance;
    repository.currentUser = null;
    repository.loans.clear();
    for (final book in repository.books) {
      book.availableCopies = book.totalCopies;
    }
    // Kekalkan satu buku tanpa stok untuk ujian "Tiada Stok".
    repository.bookById('B006').availableCopies = 0;
  });

  testWidgets('Borang kosong memaparkan ralat dan tidak menukar skrin', (tester) async {
    await tester.pumpWidget(const KptBookLoanApp());
    await tester.tap(find.widgetWithText(FilledButton, 'Hantar'));
    await tester.pump();

    expect(find.text('Sila isi nama'), findsOneWidget);
    expect(find.text('Sila isi No. IC'), findsOneWidget);
    expect(find.text('Senarai Buku'), findsNothing);
  });

  testWidgets('No. IC bukan 12 digit ditolak', (tester) async {
    await tester.pumpWidget(const KptBookLoanApp());
    await tester.enterText(find.byType(TextField).at(1), '12345');
    await tester.tap(find.widgetWithText(FilledButton, 'Hantar'));
    await tester.pump();

    expect(find.text('No. IC mesti 12 digit angka'), findsOneWidget);
  });

  testWidgets('Pendaftaran sah membuka Senarai Buku', (tester) async {
    await _register(tester);

    expect(find.text('Senarai Buku'), findsOneWidget);
    expect(find.textContaining('Ahmad bin Ali'), findsOneWidget);
  });

  testWidgets('Buku tanpa stok memaparkan Tiada Stok', (tester) async {
    await _register(tester);
    await tester.enterText(find.byType(TextField).first, 'Pentadbiran Awam');
    await tester.pumpAndSettle();

    expect(find.text('Tiada Stok'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Pinjam'));
    expect(button.onPressed, isNull);
  });

  testWidgets('Peminjaman mengurangkan salinan dan menyekat pinjaman berulang',
      (tester) async {
    await _register(tester);
    await tester.enterText(find.byType(TextField).first, 'Dasar Pendidikan');
    await tester.pumpAndSettle();

    expect(find.text('Tersedia: 3 / 3'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Pinjam'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sahkan Pinjaman'));
    await tester.pumpAndSettle();

    expect(find.text('Pinjaman berjaya'), findsOneWidget);
    expect(find.text('Tersedia: 2 / 3'), findsOneWidget);

    // Cuba pinjam buku yang sama sekali lagi.
    await tester.tap(find.widgetWithText(FilledButton, 'Pinjam'));
    await tester.pumpAndSettle();

    expect(find.text('Anda sudah meminjam buku ini.'), findsOneWidget);
    expect(AppRepository.instance.loans.length, 1);
  });

  testWidgets('Pembaharuan dan pemulangan mengemas kini rekod', (tester) async {
    await _register(tester);
    await tester.enterText(find.byType(TextField).first, 'Dasar Pendidikan');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Pinjam'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sahkan Pinjaman'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();

    final loan = AppRepository.instance.loans.first;
    final originalDueDate = loan.dueDate;

    await tester.tap(find.widgetWithText(OutlinedButton, 'Baharui'));
    await tester.pumpAndSettle();

    expect(loan.dueDate.difference(originalDueDate).inDays, 14);
    expect(find.text('Telah Dibaharui'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Baharui'), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, 'Pulang'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sahkan Pemulangan'));
    await tester.pumpAndSettle();

    expect(find.text('Pemulangan berjaya'), findsOneWidget);
    expect(find.text('Tiada rekod pinjaman.'), findsOneWidget);
    expect(AppRepository.instance.bookById('B001').availableCopies, 3);
  });
}
