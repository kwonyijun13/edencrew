import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';

// Daily prices plus the updated page cache after a multi-page fetch.
class DailyPricesResult {
  final List<DailyPrice> prices;
  final Map<int, List<DailyPrice>> cache;

  const DailyPricesResult({
    required this.prices,
    required this.cache,
  });
}
