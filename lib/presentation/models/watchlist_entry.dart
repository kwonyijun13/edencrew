import 'package:edencrew_assignment_starter/domain/entities/stock.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';

class WatchlistEntry {
  final Stock stock;

  // Null means we haven't received realtime data yet → show skeleton.
  final StockPrice? price;

  const WatchlistEntry({required this.stock, this.price});
}
