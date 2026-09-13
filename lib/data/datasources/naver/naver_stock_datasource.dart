import 'dart:convert';

import 'package:charset/charset.dart';
import 'package:edencrew_assignment_starter/core/error/app_exception.dart';
import 'package:edencrew_assignment_starter/core/network/naver_api.dart';
import 'package:edencrew_assignment_starter/data/dto/daily_price_dto.dart';
import 'package:edencrew_assignment_starter/data/dto/daily_price_page_dto.dart';
import 'package:edencrew_assignment_starter/data/dto/realtime_stock_dto.dart';
import 'package:edencrew_assignment_starter/data/dto/stock_metadata_dto.dart';
import 'package:edencrew_assignment_starter/data/dto/stock_search_dto.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class NaverStockDatasource {
  final http.Client client;
  NaverStockDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<List<StockSearchDto>> searchStocks(String query) async {
    final uri = Uri.parse(NaverApi.autocompleteBaseUrl).replace(
      queryParameters: {
        'q': query,
        'target': 'stock,ipo,index,marketindicator',
      },
    );
    final response = await client.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    final items = json['items'] ?? [];

    return items
        .whereType<Map<String, dynamic>>()
        .map(StockSearchDto.fromJson)
        .where(_isDomesticStock)
        .toList();
  }

  bool _isDomesticStock(StockSearchDto stock) {
    final isSixDigit = RegExp(r'^\d{6}$').hasMatch(stock.code);
    final isDomestic = stock.typeCode == 'KOSPI' || stock.typeCode == 'KOSDAQ';
    return isSixDigit && isDomestic;
  }

  Future<List<RealtimeStockDto>> getRealtimePrices(List<String> symbols) async {
    if (symbols.isEmpty) return [];

    final query = symbols.join(','); // 005930,000660,035720
    final uri = Uri.parse(NaverApi.realtimeBaseUrl).replace(
        queryParameters: {
          'query': 'SERVICE_ITEM:$query'
        }
    );

    /*
    GET /api/realtime?query=SERVICE_ITEM:005930,000660,035720 instead of
    GET Samsung
    GET SK Hynix
    GET Kakao
     */

    final response = await client.get(uri);
    debugPrint('status: ${response.statusCode}');
    debugPrint('headers: ${response.headers}');

    if (response.statusCode != 200) throw AppException('Failed to fetch realtime prices: ${response.statusCode}');

    final decodedBody = eucKr.decode(response.bodyBytes);
    final Map<String, dynamic> json = jsonDecode(decodedBody);

    final result = json['result'] as Map<String, dynamic>?;
    if (result == null) return [];

    final areas = result['areas'] as List<dynamic>? ?? [];

    final serviceItemArea = areas.cast<Map<String, dynamic>?>().firstWhere(
            (area) => area?['name'] == 'SERVICE_ITEM', orElse: () => null);
    if (serviceItemArea == null) return [];

    final data = serviceItemArea['datas'] as List<dynamic>? ?? [];
    return data.whereType<Map<String, dynamic>>().map(RealtimeStockDto.fromJson).toList();
  }

  Future<StockMetadataDto> getStockMetadata(String symbol) async {
    final uri = Uri.parse('${NaverApi.metadataBaseUrl}/$symbol');

    final response = await client.get(uri);
    if (response.statusCode != 200) throw AppException('Failed to fetch stock metadata: ${response.statusCode}');

    final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

    return StockMetadataDto.fromJson(json);
  }

  Future<List<DailyPriceDto>> getDailyPrices({
    required String symbol,
    required int page,
  }) async {
    final pageResult = await getDailyPricePage(symbol: symbol, page: page);
    return pageResult.prices;
  }

  /// Fetches one HTML page of daily prices and extracts [lastPage] for pagination.
  Future<DailyPricePageDto> getDailyPricePage({
    required String symbol,
    required int page,
  }) async {
    final uri = Uri.parse(NaverApi.dailyPriceBaseUrl).replace(
        queryParameters: {
          'code': symbol,
          'page': page.toString()
        }
    );

    // debugPrint('URL: $uri');

    final response = await client.get(
      uri,
      headers: {
        'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/139.0.0.0 Safari/537.36',
        'Referer': 'https://finance.naver.com/',
      },
    );

    // debugPrint('status: ${response.statusCode}');
    // debugPrint('content-type: ${response.headers['content-type']}');
    // debugPrint('body length: ${response.bodyBytes.length}');
    // debugPrint(response.body.substring(0, response.body.length > 1000 ? 1000 : response.body.length));
    if (response.statusCode != 200) throw AppException('Failed to fetch daily prices: ${response.statusCode}');

    final decodedBody = eucKr.decode(response.bodyBytes);
    final document = html_parser.parse(decodedBody);

    final rows = document.querySelectorAll('table.type2 tr');

    final prices = <DailyPriceDto>[];

    for (final row in rows) {
      final cells = row.querySelectorAll('td');

      if (cells.length != 7) {
        continue;
      }

      final dateText = cells[0].text.trim();

      // Only process rows containing a date such as 2026.09.11.
      if (!RegExp(r'^\d{4}\.\d{2}\.\d{2}$').hasMatch(dateText)) {
        continue;
      }

      final date = DateTime.tryParse(
        dateText.replaceAll('.', '-'),
      );

      if (date == null) {
        continue;
      }

      final closePrice = _parseNumber(cells[1].text);
      final changeAmount = _parseChangeAmount(cells[2]);
      final openPrice = _parseNumber(cells[3].text);
      final highPrice = _parseNumber(cells[4].text);
      final lowPrice = _parseNumber(cells[5].text);
      final tradingVolume = _parseNumber(cells[6].text);

      prices.add(
        DailyPriceDto(
          date: date,
          closePrice: closePrice,
          changeAmount: changeAmount,
          openPrice: openPrice,
          highPrice: highPrice,
          lowPrice: lowPrice,
          tradingVolume: tradingVolume,
        ),
      );
    }

    final lastPage = _extractLastPage(document);

    return DailyPricePageDto(prices: prices, lastPage: lastPage);
  }

  int _parseNumber(String value) {
    return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  // Parses the "전일비" column which may include up and down and colored spans.
  int _parseChangeAmount(dom.Element cell) {
    final text = cell.text.trim();
    final isDown = text.contains('▼') || cell.outerHtml.contains('nv01');
    final isUp = text.contains('▲') || cell.outerHtml.contains('nv02');

    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(digits) ?? 0;

    if (isDown) return -amount;
    if (isUp) return amount;
    return amount;
  }

  // Reads the highest page number from Naver's pagination links.
  int _extractLastPage(dynamic document) {
    final links = document.querySelectorAll('td.pgRR a, table.Nnavi a');
    var maxPage = 1;

    for (final link in links) {
      final href = link.attributes['href'] ?? '';
      final match = RegExp(r'page=(\d+)').firstMatch(href);
      if (match != null) {
        final pageNum = int.tryParse(match.group(1)!) ?? 1;
        if (pageNum > maxPage) maxPage = pageNum;
      }
    }

    return maxPage;
  }

}