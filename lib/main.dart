import 'package:edencrew_assignment_starter/data/datasources/naver/naver_stock_datasource.dart';
import 'package:edencrew_assignment_starter/presentation/app/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EdencrewAssignmentApp(),
    ),
  );
}

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '이든크루 평가 과제',
      theme: AppTheme.dark,
      home: const AppShell(),
    );
  }
}