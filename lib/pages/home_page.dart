import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kjv/models/verse.dart';
import 'package:kjv/pages/books_page.dart';
import 'package:kjv/pages/search_page.dart';
import 'package:kjv/providers/main_provider.dart';
import 'package:kjv/services/read_last_index.dart';
import 'package:kjv/widgets/verse_widget.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:clipboard/clipboard.dart';

// Home page of the application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Delayed execution to allow the UI to build before scrolling
    Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        MainProvider mainProvider =
            Provider.of<MainProvider>(context, listen: false);
        // Read the last index and scroll to it
        await ReadLastIndex.execute().then(
          (value) {
            if (value != null) {
              mainProvider.scrollToIndex(index: value);
            }
          },
        );
      },
    );
    super.initState();
  }

  // Process selected verses to create a formatted string
  String processSelectedVerses({required List<Verse> verses}) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();
    return "$result[KJV]";
  }

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to changes in MainProvider
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        // Extracting necessary properties from MainProvider
        List<Verse> verses = mainProvider.verses;
        Verse? currentVerse = mainProvider.currentVerse;
        bool isSelected = mainProvider.selectedVerse.isNotEmpty;

        // Building the UI with AnnotatedRegion for system UI overlay style
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).colorScheme.background,
            systemNavigationBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
          child: Scaffold(
            appBar: AppBar(
              // Conditional title for showing the current book on tap
              title: currentVerse == null || isSelected
                  ? null
                  : GestureDetector(
                      onTap: () {
                        // Navigate to BooksPage on tap
                        Get.to(
                          () => BooksPage(
                            chapterIdx: currentVerse.chapter,
                            bookIdx: currentVerse.book,
                          ),
                          transition: Transition.leftToRight,
                        );
                      },
                      child: Text(
                        currentVerse.book,
                      ),
                    ),
              // Actions in the AppBar
              actions: [
                // Copy button for selected verses
                if (isSelected)
                  IconButton(
                    onPressed: () async {
                      // Copy selected verses to clipboard
                      String string = processSelectedVerses(
                          verses: mainProvider.selectedVerse);
                      await FlutterClipboard.copy(string).then(
                        (_) => mainProvider.clearSelected(),
                      );
                    },
                    icon: const Icon(Icons.copy_outlined),
                  ),
                // Search button when no verses are selected
                if (!isSelected)
                  IconButton(
                    onPressed: () {
                      // Navigate to SearchPage on tap
                      Get.to(
                        () => SearchPage(verses: mainProvider.verses),
                        transition: Transition.rightToLeft,
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
              ],
            ),
            // Body of the Scaffold with a ScrollablePositionedList
            body: ScrollablePositionedList.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                Verse verse = verses[index];
                return VerseWidget(
                  verse: verse,
                  index: index,
                );
              },
              // Scroll controllers and listeners from MainProvider
              itemScrollController: mainProvider.itemScrollController,
              scrollOffsetController: mainProvider.scrollOffsetController,
              itemPositionsListener: mainProvider.itemPositionsListener,
              scrollOffsetListener: mainProvider.scrollOffsetListener,
            ),
          ),
        );
      },
    );
  }
}
