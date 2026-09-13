import 'package:edencrew_assignment_starter/presentation/models/watchlist_entry.dart';
import 'package:edencrew_assignment_starter/presentation/models/watchlist_sort.dart';
import 'package:edencrew_assignment_starter/presentation/providers/favorite_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/stock_repository_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/watchlist_sort_provider.dart';
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

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
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

// Applies the selected sort order without re-fetching from the network.
final sortedWatchlistProvider = Provider<List<WatchlistEntry>>((ref) {
  final asyncEntries = ref.watch(watchlistProvider);
  final sort = ref.watch(watchlistSortProvider);
  final entries = asyncEntries.value ?? [];
  return sortWatchlistEntries(entries, sort);
});

List<WatchlistEntry> sortWatchlistEntries(
    List<WatchlistEntry> entries,
    WatchlistSort sort,
    ) {
  final sorted = [...entries];

  switch (sort) {
    case WatchlistSort.price:
      sorted.sort((a, b) {
        final aPrice = a.price?.currentPrice;
        final bPrice = b.price?.currentPrice;
        // Rows without price go to the bottom (our design decision).
        if (aPrice == null && bPrice == null) return 0;
        if (aPrice == null) return 1;
        if (bPrice == null) return -1;
        return bPrice.compareTo(aPrice);
      });
    case WatchlistSort.changeRate:
      sorted.sort((a, b) {
        final aRate = a.price?.changeRate;
        final bRate = b.price?.changeRate;
        if (aRate == null && bRate == null) return 0;
        if (aRate == null) return 1;
        if (bRate == null) return -1;
        return bRate.compareTo(aRate);
      });
    case WatchlistSort.name:
      sorted.sort((a, b) => a.stock.name.compareTo(b.stock.name));
  }

  return sorted;
}
