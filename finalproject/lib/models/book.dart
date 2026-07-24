class Book {
  final String id;
  final String title;
  final String ssdn;
  final String publisher;
  final int totalCopies;
  int availableCopies;

  Book({
    required this.id,
    required this.title,
    required this.ssdn,
    required this.publisher,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;
}
