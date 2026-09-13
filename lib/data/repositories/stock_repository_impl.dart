import 'package:edencrew_assignment_starter/data/datasources/naver/naver_stock_datasource.dart';
import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/daily_prices_result.dart';
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
    final dtos = await datasource.getDailyPrices(symbol: symbol, page: page);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<DailyPricesResult> getDailyPricesForPages({
    required String symbol,
    required int pageCount,
    Map<int, List<DailyPrice>> cache = const {},
  }) async {
    if (pageCount <= 0) {
      return DailyPricesResult(prices: const [], cache: cache);
    }

    final mutableCache = Map<int, List<DailyPrice>>.from(cache);
    var lastPage = 1;

    // Fetch page 1 first to learn total available pages from HTML pagination.
    if (!mutableCache.containsKey(1)) {
      final first = await datasource.getDailyPricePage(symbol: symbol, page: 1);
      lastPage = first.lastPage;
      mutableCache[1] = first.prices.map((dto) => dto.toDomain()).toList();
    } else {
      final first = await datasource.getDailyPricePage(symbol: symbol, page: 1);
      lastPage = first.lastPage;
    }

    final targetPages = pageCount.clamp(1, lastPage);

    for (var page = 2; page <= targetPages; page++) {
      if (mutableCache.containsKey(page)) continue;

      final result = await datasource.getDailyPricePage(
        symbol: symbol,
        page: page,
      );
      mutableCache[page] = result.prices.map((dto) => dto.toDomain()).toList();
    }

    final allPrices = <DailyPrice>[];
    for (var page = 1; page <= targetPages; page++) {
      allPrices.addAll(mutableCache[page] ?? []);
    }

    // Naver lists newest first; chart needs oldest → newest.
    allPrices.sort((a, b) => a.date.compareTo(b.date));

    return DailyPricesResult(prices: allPrices, cache: mutableCache);
  }
}