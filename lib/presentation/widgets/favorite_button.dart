import 'package:edencrew_assignment_starter/presentation/providers/favorite_provider.dart';
import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.symbol,
    this.onToggled,
    this.size = 24,
  });

  final String symbol;
  final void Function(bool isNowFavorite)? onToggled;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isFavorite = ref.watch(favoritesProvider).contains(symbol);

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        ref.read(favoritesProvider.notifier).toggle(symbol);
        onToggled?.call(!isFavorite);
      },
      icon: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
        color: isFavorite ? colors.favoriteActive : colors.favoriteInactive,
        size: size,
      ),
    );
  }
}