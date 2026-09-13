import 'package:edencrew_assignment_starter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('앱이 다크 테마로 시작하고 관심 빈 상태가 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EdencrewAssignmentApp(),
      ),
    );

    expect(find.text('관심 종목이 없습니다'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
  });
}
