import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/theme/app_colors.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

// Simple candlestick chart drawn with [CustomPainter].
// Assignment allows chart rendering details to differ; colors must match tokens.
class CandlestickChart extends StatelessWidget {
  const CandlestickChart({
    super.key,
    required this.prices,
    this.height = 200,
  });

  final List<DailyPrice> prices;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            '차트 데이터 없음',
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _CandlestickPainter(
          prices: prices,
          colors: context.colors,
        ),
      ),
    );
  }
}

class _CandlestickPainter extends CustomPainter {
  _CandlestickPainter({required this.prices, required this.colors});

  final List<DailyPrice> prices;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    var minPrice = prices.first.lowPrice.toDouble();
    var maxPrice = prices.first.highPrice.toDouble();

    for (final price in prices) {
      minPrice = minPrice < price.lowPrice ? minPrice : price.lowPrice.toDouble();
      maxPrice = maxPrice > price.highPrice ? maxPrice : price.highPrice.toDouble();
    }

    final range = maxPrice - minPrice;
    if (range <= 0) return;

    final candleWidth = size.width / prices.length * 0.6;
    final gap = size.width / prices.length;

    for (var i = 0; i < prices.length; i++) {
      final price = prices[i];
      final isUp = price.closePrice >= price.openPrice;
      final color = isUp ? colors.chartLineUp : colors.chartLineDown;

      final x = gap * i + gap / 2;
      final highY = _mapY(price.highPrice, minPrice, range, size.height);
      final lowY = _mapY(price.lowPrice, minPrice, range, size.height);
      final openY = _mapY(price.openPrice, minPrice, range, size.height);
      final closeY = _mapY(price.closePrice, minPrice, range, size.height);

      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1;

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), wickPaint);

      final bodyTop = openY < closeY ? openY : closeY;
      final bodyBottom = openY > closeY ? openY : closeY;
      final bodyHeight = (bodyBottom - bodyTop).clamp(1.0, size.height);

      final bodyRect = Rect.fromCenter(
        center: Offset(x, bodyTop + bodyHeight / 2),
        width: candleWidth,
        height: bodyHeight,
      );

      canvas.drawRect(bodyRect, Paint()..color = color);
    }
  }

  double _mapY(int price, double min, double range, double height) {
    return height - ((price - min) / range * height);
  }

  @override
  bool shouldRepaint(covariant _CandlestickPainter oldDelegate) {
    return oldDelegate.prices != prices;
  }
}
