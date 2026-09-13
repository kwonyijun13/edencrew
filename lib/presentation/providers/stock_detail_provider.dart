import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/presentation/models/chat_period.dart';
import 'package:edencrew_assignment_starter/presentation/providers/stock_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// All data needed to render the stock detail screen.
class StockDetailState {
  final Stock stock;
  final StockPrice? price;
  final List<DailyPrice> dailyPrices;
  final ChartPeriod period;

  const StockDetailState({
    required this.stock,
    this.price,
    required this.dailyPrices,
    required this.period,
  });
}

// Selected chart period per stock symbol.
final chartPeriodProvider = NotifierProvider.family<ChartPeriodNotifier, ChartPeriod, String>(
  ChartPeriodNotifier.new,
);

class ChartPeriodNotifier extends Notifier<ChartPeriod> {
  ChartPeriodNotifier(this.symbol);
  final String symbol;

  @override
  ChartPeriod build() => ChartPeriod.oneMonth;

  void setPeriod(ChartPeriod period) => state = period;
}

// In-memory cache of already-fetched HTML pages per symbol.
// Switching from 1개월 → 1년 reuses pages 1–2 instead of re-downloading them.
final dailyPriceCacheProvider = NotifierProvider.family<DailyPriceCacheNotifier, Map<int, List<DailyPrice>>, String>(
  DailyPriceCacheNotifier.new,
);

class DailyPriceCacheNotifier extends Notifier<Map<int, List<DailyPrice>>> {
  DailyPriceCacheNotifier(this.symbol);
  final String symbol;

  @override
  Map<int, List<DailyPrice>> build() => {};

  void update(Map<int, List<DailyPrice>> cache) => state = cache;
}

// Loads detail data whenever symbol or chart period changes.
final stockDetailProvider = FutureProvider.family<StockDetailState, String>(
      (ref, symbol) async {
    final period = ref.watch(chartPeriodProvider(symbol));
    final repository = ref.read(stockRepositoryProvider);
    final cache = ref.read(dailyPriceCacheProvider(symbol));

    final stocks = await repository.getStocksMetadata([symbol]);
    final prices = await repository.getRealtimePrices([symbol]);
    final dailyResult = await repository.getDailyPricesForPages(
      symbol: symbol,
      pageCount: period.pageCount,
      cache: cache,
    );

    // Persist newly fetched pages for future period switches.
    ref.read(dailyPriceCacheProvider(symbol).notifier).update(dailyResult.cache);

    return StockDetailState(
      stock: stocks.first,
      price: prices[symbol],
      dailyPrices: dailyResult.prices,
      period: period,
    );
  },
);
