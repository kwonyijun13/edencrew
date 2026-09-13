import 'package:edencrew_assignment_starter/domain/entities/stock_search_result.dart';
import 'package:edencrew_assignment_starter/presentation/providers/stock_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Current text in the search bar — drives which results to show.
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

// Fetches autocomplete results whenever the query changes.
final searchResultsProvider =
AsyncNotifierProvider<SearchResultsNotifier, List<StockSearchResult>>(
  SearchResultsNotifier.new,
);

class SearchResultsNotifier extends AsyncNotifier<List<StockSearchResult>> {
  @override
  Future<List<StockSearchResult>> build() async {
    final query = ref.watch(searchQueryProvider).trim();
    if (query.isEmpty) return [];

    final repository = ref.read(stockRepositoryProvider);
    return repository.searchStocks(query);
  }
}
