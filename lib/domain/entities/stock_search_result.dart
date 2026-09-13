class StockSearchResult {
  final String id;
  final String symbol;
  final String name;
  final String market;

  const StockSearchResult({
    required this.id,
    required this.symbol,
    required this.name,
    required this.market,
  });
}

// domestic:{symbol}