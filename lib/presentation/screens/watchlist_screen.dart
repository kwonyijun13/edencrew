import 'package:edencrew_assignment_starter/presentation/providers/favorite_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/watchlist_provider.dart';
import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screen 01 · 관심 — watchlist of favorite stocks with live prices.

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dimens = context.dimens;
    final favorites = ref.watch(favoritesProvider);
    final watchlistAsync = ref.watch(watchlistProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              dimens.space4,
              dimens.space4,
              dimens.space4,
              dimens.space3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '관심',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 28,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
