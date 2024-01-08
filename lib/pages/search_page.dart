import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kjv/models/verse.dart';
import 'package:kjv/providers/main_provider.dart';
import 'package:kjv/utils/format_searched_text.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final List<Verse> verses;
  const SearchPage({super.key, required this.verses});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controllers and list for managing search functionality
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final List<Verse> _results = [];

  // Method to perform the search
  Future<void> search() async {
    setState(() {
      _results.clear();
    });

    for (var verse in widget.verses) {
      // Matching verses based on the trimmed and lowercase text
      bool matchVerse = verse.text
          .trim()
          .replaceAll(" ", "")
          .toLowerCase()
          .contains(_textEditingController.text
              .trim()
              .replaceAll(" ", "")
              .toLowerCase());
      if (matchVerse) {
        bool contains = _results.any((element) => element == verse);
        if (!contains) {
          setState(() {
            _results.add(verse);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Search input field in the app bar
        title: TextField(
          autofocus: true,
          controller: _textEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
          ),
          onChanged: (o) => setState(() {}),
          onSubmitted: (s) async =>
              await search().then((_) => _scrollController.jumpTo(0.0)),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          // Clear search button when there's input
          if (_textEditingController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _textEditingController.clear();
                  _results.clear();
                });
              },
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),

      // List view to display search results
      body: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: _results.length,
        itemBuilder: (context, index) {
          Verse verse = _results[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).hoverColor),
              ),
            ),
            child: ListTile(
              onTap: () {
                // Scroll to the selected verse and close the search page
                MainProvider mainProvider =
                    Provider.of<MainProvider>(context, listen: false);
                int idx = mainProvider.verses.indexWhere((element) =>
                    element.chapter == verse.chapter &&
                    element.book == verse.book &&
                    element.verse == verse.verse);
                mainProvider.scrollToIndex(index: idx);
                Get.back();
              },
              title: formatSearchText(
                  input: verse.text.trim(),
                  text: _textEditingController.text.trim(),
                  context: context),
              subtitle: Text("${verse.book} ${verse.chapter}:${verse.verse}"),
            ),
          );
        },
      ),
    );
  }
}
