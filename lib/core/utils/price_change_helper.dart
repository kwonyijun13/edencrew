import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Describes whether a stock moved up, down, or stayed flat.
// Korean markets use red for up and blue for down — opposite of US markets.
enum PriceDirection { up, down, flat }

// Shared logic for price-change colors and labels used across all screens.
class PriceChangeHelper {
  PriceChangeHelper._();

  static PriceDirection direction(int changeAmount) {
    if (changeAmount > 0) return PriceDirection.up;
    if (changeAmount < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }

  static PriceDirection fromRate(double changeRate) {
    if (changeRate > 0) return PriceDirection.up;
    if (changeRate < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }

  // Picks the correct semantic color token for the change direction.
  static Color textColor(AppColors colors, PriceDirection dir) {
    switch (dir) {
      case PriceDirection.up:
        return colors.priceUpText;
      case PriceDirection.down:
        return colors.priceDownText;
      case PriceDirection.flat:
        return colors.priceFlatText;
    }
  }

  // Arrow prefix shown on the detail screen header.
  static String arrow(PriceDirection dir) {
    switch (dir) {
      case PriceDirection.up:
        return '▲';
      case PriceDirection.down:
        return '▼';
      case PriceDirection.flat:
        return '';
    }
  }

  // Formats `-400 (-0.22%)` style text from a [StockPrice].
  static String formatChangeLine(StockPrice price) {
    final amount = price.changeAmount;
    final sign = amount > 0 ? '+' : '';
    final rate = (price.changeRate * 100).toStringAsFixed(2);
    return '$sign$amount ($sign$rate%)';
  }

  // Formats daily table change cell with explicit sign.
  static String formatDailyChange(int changeAmount) {
    if (changeAmount > 0) return '+$changeAmount';
    return changeAmount.toString();
  }
}
