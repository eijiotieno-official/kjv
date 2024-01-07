class Verse {
  final String book; // Name of the book
  final int chapter; // Chapter number
  final int verse; // Verse number
  final String text; // Text content of the verse

  // Constructor to initialize the Verse object
  Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  // Factory method to create a Verse object from JSON data
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      book: json['book'],
      chapter: int.parse(json['chapter']),
      verse: int.parse(json['verse']),
      text: json['text'],
    );
  }
}
