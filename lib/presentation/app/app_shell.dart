import 'package:edencrew_assignment_starter/presentation/providers/main_tab_provider.dart';
import 'package:edencrew_assignment_starter/presentation/screens/search_screen.dart';
import 'package:edencrew_assignment_starter/presentation/screens/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Root shell: switches between watchlist and search via bottom tabs.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: ref.watch(mainTabProvider),
          children: [WatchlistScreen(), SearchScreen()],
        ),
        bottomNavigationBar: AppBottomNav(),
      ),
    );
  }
}