import 'package:edencrew_assignment_starter/presentation/models/watchlist_entry.dart';
import 'package:edencrew_assignment_starter/presentation/models/watchlist_sort.dart';
import 'package:edencrew_assignment_starter/presentation/providers/favorite_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/watchlist_provider.dart';
import 'package:edencrew_assignment_starter/presentation/providers/watchlist_sort_provider.dart';
import 'package:edencrew_assignment_starter/presentation/screens/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/price_change_text.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/skeleton_box.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/sort_bottom_sheet.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/stock_subtitle.dart';
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
    final sortedEntries = ref.watch(sortedWatchlistProvider);
    final sort = ref.watch(watchlistSortProvider);

    return Column(
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
              if (favorites.isNotEmpty) ...[
                _SortChip(
                  label: sort.label,
                  onTap: () => SortBottomSheet.show(context),
                ),
                SizedBox(width: dimens.space2),
                IconButton(
                  onPressed: () =>
                      ref.read(watchlistProvider.notifier).refresh(),
                  icon: Icon(Icons.refresh_rounded, color: colors.textPrimary),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: favorites.isEmpty
              ? const EmptyState(
            icon: Icons.star_border_rounded,
            title: '관심 종목이 없습니다',
            subtitle: '검색 탭에서 종목을 찾아 별 아이콘을 눌러 추가해 주세요.',
          )
              : watchlistAsync.when(
            loading: () =>
            const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                '시세를 불러오지 못했습니다',
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            data: (_) => ListView.separated(
              itemCount: sortedEntries.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: colors.borderSubtle,
                indent: dimens.space4,
                endIndent: dimens.space4,
              ),
              itemBuilder: (context, index) {
                return _WatchlistRow(entry: sortedEntries[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dimens.radiusMd),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space3,
          vertical: dimens.space2,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: AppTypography.medium,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: colors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _WatchlistRow extends StatelessWidget {
  const _WatchlistRow({required this.entry});

  final WatchlistEntry entry;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final stock = entry.stock;
    final price = entry.price;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => StockDetailScreen(symbol: stock.symbol),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space4,
          vertical: dimens.space3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.name,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: AppTypography.medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  StockSubtitle(symbol: stock.symbol, market: stock.market),
                ],
              ),
            ),
            if (price != null)
              PriceChangeText(price: price)
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(width: 72, height: 16),
                  SizedBox(height: 6),
                  SkeletonBox(width: 96, height: 14),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
