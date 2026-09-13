import 'package:edencrew_assignment_starter/data/datasources/naver/naver_stock_datasource.dart';
import 'package:edencrew_assignment_starter/data/repositories/stock_repository_impl.dart';
import 'package:edencrew_assignment_starter/domain/repositories/stock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  final dataSource = NaverStockDatasource();
  return StockRepositoryImpl(datasource: dataSource);
});