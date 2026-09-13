import 'package:edencrew_assignment_starter/core/utils/number_formatter.dart';
import 'package:edencrew_assignment_starter/core/utils/price_change_helper.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// Displays current price and change line with correct up/down/flat colors.
class PriceChangeText extends StatelessWidget {
  const PriceChangeText({
    super.key,
    required this.price,
    this.large = false,
  });

  final StockPrice price;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final direction = PriceChangeHelper.direction(price.changeAmount);
    final changeColor = PriceChangeHelper.textColor(colors, direction);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          NumberFormatter.withCommas(price.currentPrice),
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: large ? 28 : 15,
            fontWeight: AppTypography.medium,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          PriceChangeHelper.formatChangeLine(price),
          style: TextStyle(
            color: changeColor,
            fontSize: large ? 15 : 13,
            fontWeight: AppTypography.regular,
          ),
        ),
      ],
    );
  }
}

/// Large header price with ▲/▼ arrow prefix (detail screen).
class DetailPriceHeader extends StatelessWidget {
  const DetailPriceHeader({super.key, required this.price});

  final StockPrice price;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final direction = PriceChangeHelper.direction(price.changeAmount);
    final changeColor = PriceChangeHelper.textColor(colors, direction);
    final arrow = PriceChangeHelper.arrow(direction);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          NumberFormatter.withCommas(price.currentPrice),
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 32,
            fontWeight: AppTypography.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$arrow ${PriceChangeHelper.formatChangeLine(price)}'.trim(),
          style: TextStyle(
            color: changeColor,
            fontSize: 15,
            fontWeight: AppTypography.regular,
          ),
        ),
      ],
    );
  }
}
