import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

// Bottom toast shown when adding/removing favorites on the search screen.
// Auto-dismisses after [duration] — Figma doesn't specify timing; 2s is reasonable.
class FavoriteToast {
  static OverlayEntry? _currentEntry;

  static void show(
      BuildContext context, {
        required bool added,
        Duration duration = const Duration(seconds: 2),
      }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    final colors = context.colors;
    final dimens = context.dimens;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: dimens.space4,
        right: dimens.space4,
        bottom: dimens.tabBarHeight + bottomInset + dimens.space3,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.space4,
              vertical: dimens.space3,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: BorderRadius.circular(dimens.radiusLg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  added ? Icons.star_rounded : Icons.star_border_rounded,
                  color: added ? colors.favoriteActive : colors.favoriteInactive,
                  size: dimens.iconMd,
                ),
                SizedBox(width: dimens.space2),
                Text(
                  added ? '관심이 등록되었습니다' : '관심이 해제되었습니다',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    Future<void>.delayed(duration, () {
      if (_currentEntry == entry) {
        entry.remove();
        _currentEntry = null;
      }
    });
  }
}
