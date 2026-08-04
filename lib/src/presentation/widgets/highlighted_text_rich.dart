import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final Set<String> terms;
  final TextStyle? style;
  final Color? highlightColor;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightText({
    super.key,
    this.style,
    this.highlightColor,
    this.maxLines,
    this.overflow,
    required this.text,
    required this.terms,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      _buildSpans(
        text: text,
        terms: terms,
        style: style,
        highlightStyle: style?.copyWith(
          backgroundColor:
              highlightColor ?? ColorScheme.of(context).primary.withAlpha(102),
        ),
      ),
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }

  static TextSpan _buildSpans({
    required String text,
    required Set<String> terms,
    TextStyle? style,
    TextStyle? highlightStyle,
  }) {
    final pattern = _compiledPatternFor(terms);
    if (pattern == null) {
      return TextSpan(text: text, style: style);
    }

    final matches = pattern.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <TextSpan>[];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: style),
        );
      }

      spans.add(TextSpan(text: match.group(0), style: highlightStyle));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans);
  }
}

// A single search's [terms] Set is reused (by reference) by every
// HighlightText built during that search — ConfigNotifier only replaces it
// on a new query — so caching by identity avoids recompiling the same
// pattern for every visible list item while scrolling a search result.
Set<String>? _cachedTerms;
RegExp? _cachedPattern;

RegExp? _compiledPatternFor(Set<String> terms) {
  if (terms.isEmpty) return null;
  if (identical(_cachedTerms, terms)) return _cachedPattern;

  final escaped = terms.map(RegExp.escape);
  final pattern = RegExp('(${escaped.join('|')})', caseSensitive: false);
  _cachedTerms = terms;
  _cachedPattern = pattern;
  return pattern;
}
