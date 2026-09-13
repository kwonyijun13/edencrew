import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';

class DailyPriceDto {
  final DateTime date;
  final int closePrice;
  final int changeAmount;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;

  const DailyPriceDto({
    required this.date,
    required this.closePrice,
    required this.changeAmount,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradingVolume,
  });

  DailyPrice toDomain() {
    return DailyPrice(
      date: date,
      closePrice: closePrice,
      changeAmount: changeAmount,
      openPrice: openPrice,
      highPrice: highPrice,
      lowPrice: lowPrice,
      tradingVolume: tradingVolume,
    );
  }
}

/*
This is different from the rest as there is no JSON to parse. Here is HTML.
 */