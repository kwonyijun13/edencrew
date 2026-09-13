// Sort options for the watchlist screen (matches Figma bottom sheet).
enum WatchlistSort {
  // 현재가순 — highest current price first.
  price,

  // 등락률순 — largest % change first.
  changeRate,

  // 가나다순 — Korean alphabetical by stock name.
  name,
}

extension WatchlistSortLabel on WatchlistSort {
  /// Label shown in the header chip and sort bottom sheet.
  String get label {
    switch (this) {
      case WatchlistSort.price:
        return '현재가순';
      case WatchlistSort.changeRate:
        return '등락률순';
      case WatchlistSort.name:
        return '가나다순';
    }
  }
}