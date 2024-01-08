import 'package:flutter/material.dart';

// Function to format searched text with highlighted matches
Text formatSearchText({
  required String input,
  required String text,
  required BuildContext context,
}) {
  // Check if either input or text is empty
  if (input.isEmpty || text.isEmpty) {
    return Text(input);
  }

  // List to store formatted text spans
  List<TextSpan> textSpans = [];

  // Create a case-insensitive regular expression for the search text
  RegExp regExp = RegExp(text, caseSensitive: false);

  // Find all matches of the search text in the input string
  Iterable<Match> matches = regExp.allMatches(input);

  // Initialize the current index
  int currentIndex = 0;

  // Loop through the matches
  for (Match match in matches) {
    // Add non-matching text span
    textSpans.add(TextSpan(text: input.substring(currentIndex, match.start)));

    // Add matching text span with styling
    textSpans.add(
      TextSpan(
        text: input.substring(match.start, match.end),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // uPDATE the current index
    currentIndex = match.end;
  }

  // Add the remaining non-matching text span
  textSpans.add(TextSpan(text: input.substring(currentIndex)));

  // Return the formatted text with spans
  return Text.rich(TextSpan(children: textSpans));
}
