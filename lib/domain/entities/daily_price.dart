class DailyPrice {
  final DateTime date;
  final int closePrice;
  final int changeAmount;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;

  const DailyPrice({
    required this.date,
    required this.closePrice,
    required this.changeAmount,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradingVolume,
  });
}

/*
The Naver daily table provides:
종가
전일비
시가
고가
저가
거래량
 */