import 'package:edencrew_assignment_starter/domain/entities/stock_search_result.dart';

class StockSearchDto {
  final String code;
  final String name;
  final String typeCode;
  final String typeName;
  final String url;
  final String nationCode;
  final String category;

  const StockSearchDto({
    required this.code,
    required this.name,
    required this.typeCode,
    required this.typeName,
    required this.url,
    required this.nationCode,
    required this.category,
  });

  factory StockSearchDto.fromJson(Map<String, dynamic> json) {
    return StockSearchDto(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      typeCode: json['typeCode']?.toString() ?? '',
      typeName: json['typeName']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      nationCode: json['nationCode']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  StockSearchResult toDomain() {
    return StockSearchResult(
      id: 'domestic:$code',
      symbol: code,
      name: name,
      market: typeName,
    );
  }
}