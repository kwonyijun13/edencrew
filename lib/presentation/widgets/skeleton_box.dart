import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

// Placeholder block for rows still waiting on realtime price data.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width = 64,
    this.height = 14,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.feedbackSkeleton,
        borderRadius: BorderRadius.circular(context.dimens.radiusSm),
      ),
    );
  }
}
