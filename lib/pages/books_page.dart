import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kjv/models/book.dart';
import 'package:kjv/models/chapter.dart';
import 'package:kjv/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:expandable/expandable.dart';

class BooksPage extends StatefulWidget {
  final int chapterIdx;
  final String bookIdx;
  const BooksPage({super.key, required this.chapterIdx, required this.bookIdx});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  // AutoScrollController for automatic scrolling to the selected book
  final AutoScrollController _autoScrollController = AutoScrollController();

  // List of books and the current selected book
  List<Book> books = [];
  Book? currentBook;

  @override
  void initState() {
    // Accessing the MainProvider to get books and current selected book
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);
    books = mainProvider.books;
    currentBook = mainProvider.books.firstWhere(
        (element) => element.title == mainProvider.currentVerse!.book);

    // Finding the index of the current book and scrolling to it
    int index = mainProvider.books.indexOf(currentBook!);
    _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(milliseconds: (10 * books.length)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        return ExpandableNotifier(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Books"),
            ),
            body: ListView.builder(
              itemCount: books.length,
              physics: const BouncingScrollPhysics(),
              controller: _autoScrollController,
              itemBuilder: (context, index) {
                Book book = books[index];
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _autoScrollController,
                  index: index,
                  child: ListTile(
                    // ExpandablePanel to show chapters when the book is tapped
                    title: ExpandablePanel(
                      controller: ExpandableController(
                          initialExpanded: currentBook == book),
                      collapsed: const SizedBox.shrink(),
                      header: Text(book.title),
                      expanded: Wrap(
                        children: List.generate(
                          book.chapters.length,
                          (index) {
                            Chapter chapter = book.chapters[index];
                            return SizedBox(
                              height: 45,
                              width: 45,
                              child: GestureDetector(
                                onTap: () {
                                  // Scroll to the selected chapter and close the page
                                  int idx = mainProvider.verses.indexWhere(
                                      (element) =>
                                          element.chapter == chapter.title &&
                                          element.book == book.title);
                                  mainProvider.updateCurrentVerse(
                                      verse: mainProvider.verses.firstWhere(
                                          (element) =>
                                              element.chapter ==
                                                  chapter.title &&
                                              element.book == book.title));
                                  mainProvider.scrollToIndex(index: idx);
                                  Get.back();
                                },
                                child: Card(
                                  // Styling based on the selected chapter
                                  color: chapter.title == widget.chapterIdx &&
                                          widget.bookIdx == book.title
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.5)),
                                  child: Center(
                                    child: Text(
                                      chapter.title.toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
