import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';

class RealtimeStockDto {
  final String symbol;
  final int currentPrice;
  final int previousClose;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;
  final int listedStockCount;

  const RealtimeStockDto({required this.symbol, required this.currentPrice, required this.previousClose, required this.openPrice, required this.highPrice, required this.lowPrice, required this.tradingVolume, required this.listedStockCount});

  factory RealtimeStockDto.fromJson(Map<String, dynamic> json) {
    return RealtimeStockDto(
      symbol: json['cd']?.toString() ?? '',
      currentPrice: _parseInt(json['nv']),
      previousClose: _parseInt(json['pcv']),
      openPrice: _parseInt(json['ov']),
      highPrice: _parseInt(json['hv']),
      lowPrice: _parseInt(json['lv']),
      tradingVolume: _parseInt(json['aq']),
      listedStockCount: _parseInt(json['countOfListedStock']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString().replaceAll(',', '') ?? '') ?? 0;
  }

  StockPrice toDomain() {
    return StockPrice(
      symbol: symbol,
      currentPrice: currentPrice,
      previousClose: previousClose,
      openPrice: openPrice,
      highPrice: highPrice,
      lowPrice: lowPrice,
      tradingVolume: tradingVolume,
      listedStockCount: listedStockCount,
    );
  }
}

/*
cd  → symbol
nv  → current price
pcv → previous close
ov  → open
hv  → high
lv  → low
aq  → accumulated volume
countOfListedStock → listed shares

DTO is our Naver specific translation layer
 */