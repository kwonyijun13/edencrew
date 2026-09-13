import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart' show AppTypography;
import 'package:flutter/material.dart';

class StockSubtitle extends StatelessWidget {
  const StockSubtitle({
    super.key,
    required this.symbol,
    required this.market,
  });

  final String symbol;
  final String market;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$symbol · $market',
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: 13,
        fontWeight: AppTypography.regular,
      ),
    );
  }
}
