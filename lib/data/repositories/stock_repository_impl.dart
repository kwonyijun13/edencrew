import 'package:edencrew_assignment_starter/data/datasources/naver/naver_stock_datasource.dart';
import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_search_result.dart';
import 'package:edencrew_assignment_starter/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final NaverStockDatasource datasource;
  StockRepositoryImpl({required this.datasource});

  @override
  Future<List<StockSearchResult>> searchStocks(String query) async {
    final dtos = await datasource.searchStocks(query);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Stock>> getStocksMetadata(List<String> symbols) async {
    final stocks = <Stock>[];

    for (final symbol in symbols) {
      final dto = await datasource.getStockMetadata(symbol);
      stocks.add(dto.toDomain());
    }

    return stocks;
  }

  @override
  Future<Map<String, StockPrice>> getRealtimePrices(List<String> symbols) async {
    final dtos = await datasource.getRealtimePrices(symbols);
    return {for (final dto in dtos) dto.symbol: dto.toDomain()};
    // Map so watchlist can do prices['005930'] instantly
  }

  @override
  Future<List<DailyPrice>> getDailyPrices({required String symbol, required int page}) async {
    // TODO: implement getDailyPrices
    throw UnimplementedError();
  }
}