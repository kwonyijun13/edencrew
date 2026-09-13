import 'package:edencrew_assignment_starter/presentation/models/watchlist_sort.dart';
import 'package:edencrew_assignment_starter/presentation/providers/watchlist_sort_provider.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bottom sheet for choosing watchlist sort order.
class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimens.radiusLg),
        ),
      ),
      builder: (context) => const SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dimens = context.dimens;
    final current = ref.watch(watchlistSortProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          dimens.space4,
          dimens.space4,
          dimens.space4,
          dimens.space5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정렬',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 18,
                fontWeight: AppTypography.bold,
              ),
            ),
            SizedBox(height: dimens.space3),
            for (final sort in WatchlistSort.values)
              _SortOption(
                label: sort.label,
                selected: current == sort,
                onTap: () {
                  ref.read(watchlistSortProvider.notifier).setSort(sort);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: AppTypography.regular,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colors.textPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}
