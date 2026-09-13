import 'package:edencrew_assignment_starter/data/dto/daily_price_dto.dart';

class DailyPricePageDto {
  final List<DailyPriceDto> prices;
  final int lastPage;

  const DailyPricePageDto({
    required this.prices,
    required this.lastPage,
  });
}
