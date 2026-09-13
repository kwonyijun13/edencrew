class StockPrice {
  final String symbol;
  final int currentPrice;
  final int previousClose;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;
  final int listedStockCount;

  const StockPrice({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradingVolume,
    required this.listedStockCount,
  });

  // 등락액 = nv - pcv
  int get changeAmount => currentPrice - previousClose;

  // 등락률 = (nv - pcv) / pcv
  double get changeRate {
    if (previousClose == 0) return 0;
    return changeAmount / previousClose;
  }

  // 시가총액 = nv × countOfListedStock
  int get marketCap => currentPrice * listedStockCount;
}