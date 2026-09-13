import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_search_result.dart';

abstract interface class StockRepository {
  Future<List<StockSearchResult>> searchStocks(String query);
  Future<List<Stock>> getStocksMetadata(List<String> symbols);
  Future<Map<String, StockPrice>> getRealtimePrices(List<String> symbols);
  Future<List<DailyPrice>> getDailyPrices({required String symbol, required int page});
}