import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainTabProvider = NotifierProvider<MainTabNotifier, int>(
  MainTabNotifier.new,
);

class MainTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void selectTab(int index) => state = index;
}