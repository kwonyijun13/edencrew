// Pure formatting helpers for Korean stock market display conventions.
// The assignment cares about *format*, not exact live numbers.
// These functions turn raw integers into strings like `29,113천` or `1,063조`.
class NumberFormatter {
  NumberFormatter._();

  // Adds thousand separators: `179700` → `179,700`.
  static String withCommas(int value) {
    final text = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  // Trading volume in 천 (thousands): `29113000` → `29,113천`.
  static String formatVolume(int volume) {
    final inThousands = (volume / 1000).round();
    return '${withCommas(inThousands)}천';
  }

  // Market cap in 조 (trillion won): uses Korean 1조 = 10^12.
  static String formatMarketCap(int marketCap) {
    const trillion = 1000000000000;
    final inTrillions = (marketCap / trillion).round();
    return '${withCommas(inTrillions)}조';
  }

  // Percent with two decimals: `0.0022` → `0.22`.
  static String formatPercent(double rate) {
    return (rate * 100).toStringAsFixed(2);
  }
}
