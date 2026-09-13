import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.fontSize = 16,
  });

  final String text;
  final String query;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: fontSize,
          fontWeight: AppTypography.medium,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmedQuery.length),
          style: TextStyle(color: colors.searchHighlight),
        ),
      );

      start = index + trimmedQuery.length;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: fontSize,
          fontWeight: AppTypography.medium,
        ),
        children: spans,
      ),
    );
  }
}
