import 'package:edencrew_assignment_starter/presentation/models/watchlist_sort.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Holds the currently selected watchlist sort option.
final watchlistSortProvider = NotifierProvider<WatchlistSortNotifier, WatchlistSort>(
  WatchlistSortNotifier.new,
);

class WatchlistSortNotifier extends Notifier<WatchlistSort> {
  @override
  WatchlistSort build() => WatchlistSort.name;

  void setSort(WatchlistSort sort) => state = sort;
}
