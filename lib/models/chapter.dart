import 'verse.dart'; // Importing the 'Verse' class for the use of Verse objects

class Chapter {
  final int title; // Title of the chapter (assuming it's an integer)
  final List<Verse>
      verses; // List of Verse objects representing the verses in the chapter

  // Constructor to initialize the Chapter object
  Chapter({
    required this.title,
    required this.verses,
  });
}
