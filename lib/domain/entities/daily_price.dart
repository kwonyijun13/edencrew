class DailyPrice {
  final DateTime date;
  final int closePrice;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;

  const DailyPrice({
    required this.date,
    required this.closePrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradingVolume,
  });

  int get changeAmount {
    return 0;
  }
}