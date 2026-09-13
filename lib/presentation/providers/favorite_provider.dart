import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider = NotifierProvider<Favorites, Set<String>>(Favorites.new);

class Favorites extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String symbol) {
    final updated = {...state};
    updated.contains(symbol)
      ? updated.remove(symbol)
      : updated.add(symbol);
    state = updated;
  }
}

// Why global? Assignment: star must sync across watchlist, search, and detail.