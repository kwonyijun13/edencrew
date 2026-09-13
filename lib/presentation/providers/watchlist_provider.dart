import 'package:edencrew_assignment_starter/presentation/models/watchlist_entry.dart';
import 'package:edencrew_assignment_starter/presentation/providers/favorite_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/stock_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchlistProvider = AsyncNotifierProvider<WatchlistNotifier, List<WatchlistEntry>>(
  WatchlistNotifier.new,
);

class WatchlistNotifier extends AsyncNotifier<List<WatchlistEntry>> {
  @override
  Future<List<WatchlistEntry>> build() async {
    ref.watch(favoritesProvider);  // re-fetch when favorites change
    return _load();
  }

  Future<List<WatchlistEntry>> _load() async {
    final symbols = ref.read(favoritesProvider).toList();
    if (symbols.isEmpty) return [];

    final repo = ref.read(stockRepositoryProvider);
    final stocks = await repo.getStocksMetadata(symbols);
    final prices = await repo.getRealtimePrices(symbols);  // ONE batch call

    return stocks.map((s) => WatchlistEntry(
      stock: s,
      price: prices[s.symbol],  // null → show skeleton
    )).toList();
  }
}