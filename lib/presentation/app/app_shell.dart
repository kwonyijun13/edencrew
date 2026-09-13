import 'package:edencrew_assignment_starter/presentation/providers/main_tab_provider.dart';
import 'package:edencrew_assignment_starter/presentation/screens/search_screen.dart';
import 'package:edencrew_assignment_starter/presentation/screens/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/app_bottom_nav.dart';
import 'package:edencrew_assignment_starter/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Root shell: switches between watchlist and search via bottom tabs.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(mainTabProvider);

    return Scaffold(
      backgroundColor: context.colors.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: currentTab,
          children: const [
            WatchlistScreen(),
            SearchScreen(),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: AppBottomNav(),
      ),
    );
  }
}