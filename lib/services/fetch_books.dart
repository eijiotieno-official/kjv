import 'package:kjv/models/book.dart';
import 'package:kjv/models/chapter.dart';
import 'package:kjv/providers/main_provider.dart';

import '../models/verse.dart';

// Class responsible for fetching books based on the provided verses
class FetchBooks {
  // Static method to execute the fetching process
  static Future<void> execute({
    required MainProvider mainProvider,
    required List<Verse> verses,
  }) async {
    // Extract unique book titles from the list of verses
    List<String> bookTitles = verses.map((e) => e.book).toSet().toList();

    // Iterate through each unique book title to organize chapters and verses
    for (var bookTitle in bookTitles) {
      // Filter verses based on the current book title
      List<Verse> availableVerse =
          verses.where((v) => v.book == bookTitle).toList();

      // Extract unique chapter numbers from the filtered verses
      List<int> availableChapters =
          availableVerse.map((e) => e.chapter).toSet().toList();

      List<Chapter> chapters = [];

      // Iterate through each unique chapter number to organize verses
      for (var element in availableChapters) {
        // Create a Chapter object for each unique chapter
        Chapter chapter = Chapter(
          title: element,
          verses: availableVerse.where((v) => v.chapter == element).toList(),
        );
        chapters.add(chapter);
      }

      // Create a Book object for the current book title and its organized chapters
      Book book = Book(
        title: bookTitle,
        chapters: chapters,
      );

      // Add the created Book to the mainProvider's list of books
      mainProvider.addBook(book: book);
    }
  }
}
