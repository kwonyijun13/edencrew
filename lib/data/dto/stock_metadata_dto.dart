import 'package:edencrew_assignment_starter/domain/entities/stock.dart';

class StockMetadataDto {
  final String symbol;
  final String name;
  final String market;

  const StockMetadataDto({required this.symbol, required this.name, required this.market});

  factory StockMetadataDto.fromJson(Map<String, dynamic> json) {
    return StockMetadataDto(
      symbol: json['symbolCode']?.toString() ?? '',
      name: json['stockName']?.toString() ?? '',
      market: json['stockExchangeNameKor']?.toString() ?? '',
    );
  }

  Stock toDomain() {
    return Stock(symbol: symbol, name: name, market: market);
  }
}

/*
The mapping is:
Naver API                 DTO             Domain
symbolCode       ───────> symbol   ────> Stock.symbol
stockName        ───────> name     ────> Stock.name
stockExchange... ───────> market   ────> Stock.market
 */