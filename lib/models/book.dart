import 'chapter.dart'; // Importing the 'Chapter' class for the use of Chapter objects

class Book {
  final String title; // Title of the book
  final List<Chapter>
      chapters; // List of Chapter objects representing the chapters in the book

  // Constructor to initialize the Book object
  Book({
    required this.title,
    required this.chapters,
  });
}
