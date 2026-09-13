import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:flutter/material.dart';

// Reusable centered empty state with icon + title + subtitle.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: colors.textDisabled),
            SizedBox(height: dimens.space4),
            Text(
              title,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: AppTypography.medium,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: dimens.space2),
            Text(
              subtitle,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                fontWeight: AppTypography.regular,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}