import 'package:edencrew_assignment_starter/core/utils/number_formatter.dart';
import 'package:edencrew_assignment_starter/core/utils/price_change_helper.dart';
import 'package:edencrew_assignment_starter/domain/entities/daily_price.dart';
import 'package:edencrew_assignment_starter/domain/entities/stock_price.dart';
import 'package:edencrew_assignment_starter/presentation/models/chat_period.dart';
import 'package:edencrew_assignment_starter/presentation/providers/stock_detail_provider.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/candlestick_chart.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/favorite_button.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/price_change_text.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/stock_subtitle.dart';
import 'package:edencrew_assignment_starter/theme/app_typography.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screen 03 · 종목상세 — price, chart, summary, and daily table.
class StockDetailScreen extends ConsumerWidget {
  const StockDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dimens = context.dimens;
    final detailAsync = ref.watch(stockDetailProvider(symbol));
    final period = ref.watch(chartPeriodProvider(symbol));

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              '종목 정보를 불러오지 못했습니다',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          data: (state) {
            final stock = state.stock;
            final price = state.price;
            final reversedDaily = state.dailyPrices.reversed.toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      dimens.space2,
                      dimens.space2,
                      dimens.space4,
                      dimens.space4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: colors.textPrimary,
                                size: 20,
                              ),
                            ),
                            const Spacer(),
                            FavoriteButton(symbol: symbol, size: 28),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dimens.space2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock.name,
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                              SizedBox(height: dimens.space1),
                              StockSubtitle(
                                symbol: stock.symbol,
                                market: stock.market,
                              ),
                              SizedBox(height: dimens.space4),
                              if (price != null)
                                DetailPriceHeader(price: price)
                              else
                                Text(
                                  '—',
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: 32,
                                  ),
                                ),
                              SizedBox(height: dimens.space5),
                              _PeriodTabs(
                                selected: period,
                                onSelected: (selected) => ref
                                  .read(chartPeriodProvider(symbol).notifier)
                                  .setPeriod(selected),
                              ),
                              SizedBox(height: dimens.space4),
                              CandlestickChart(prices: state.dailyPrices),
                              SizedBox(height: dimens.space5),
                              if (price != null)
                                _SummaryGrid(price: price)
                              else
                                const SizedBox.shrink(),
                              SizedBox(height: dimens.space5),
                              Text(
                                '일별 시세',
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                              SizedBox(height: dimens.space3),
                              _DailyTableHeader(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final daily = reversedDaily[index];
                      return _DailyPriceRow(daily: daily);
                    },
                    childCount: reversedDaily.length,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: dimens.space6)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({required this.selected, required this.onSelected});

  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Row(
      children: ChartPeriod.values.map((period) {
        final isSelected = period == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: period == ChartPeriod.oneYear ? 0 : dimens.space2),
            child: InkWell(
              onTap: () => onSelected(period),
              borderRadius: BorderRadius.circular(dimens.radiusMd),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: dimens.space2),
                decoration: BoxDecoration(
                  color: isSelected ? colors.accentBg : colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(dimens.radiusMd),
                ),
                child: Text(
                  period.label,
                  style: TextStyle(
                    color: isSelected ? colors.accentDefault : colors.textSecondary,
                    fontSize: 13,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.price});

  final StockPrice price;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final cards = [
      _SummaryCard(label: '시가', value: NumberFormatter.withCommas(price.openPrice)),
      _SummaryCard(label: '고가', value: NumberFormatter.withCommas(price.highPrice)),
      _SummaryCard(label: '저가', value: NumberFormatter.withCommas(price.lowPrice)),
      _SummaryCard(label: '거래량', value: NumberFormatter.formatVolume(price.tradingVolume)),
      _SummaryCard(label: '시가총액', value: NumberFormatter.formatMarketCap(price.marketCap)),
    ];

    // Wrap sizes each card to its content instead of forcing a fixed aspect ratio.
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - dimens.space2) / 2;

        return Wrap(
          spacing: dimens.space2,
          runSpacing: dimens.space2,
          children: [
            for (final card in cards)
              SizedBox(width: itemWidth, child: card),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      padding: EdgeInsets.all(dimens.space3),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: AppTypography.regular,
              height: 1.2,
            ),
          ),
          SizedBox(height: dimens.space1),
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: AppTypography.medium,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DailyTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    TextStyle headerStyle = TextStyle(
      color: colors.textTertiary,
      fontSize: 12,
      fontWeight: AppTypography.medium,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: dimens.space2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('날짜', style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text('종가', style: headerStyle, textAlign: TextAlign.end),
          ),
          Expanded(
            flex: 2,
            child: Text('등락', style: headerStyle, textAlign: TextAlign.end),
          ),
          Expanded(
            flex: 2,
            child: Text('거래량', style: headerStyle, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class _DailyPriceRow extends StatelessWidget {
  const _DailyPriceRow({required this.daily});

  final DailyPrice daily;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final direction = PriceChangeHelper.direction(daily.changeAmount);
    final changeColor = PriceChangeHelper.textColor(colors, direction);
    final dateLabel =
        '${daily.date.month.toString().padLeft(2, '0')}.${daily.date.day.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: dimens.borderHairline),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              dateLabel,
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              NumberFormatter.withCommas(daily.closePrice),
              style: TextStyle(color: colors.textPrimary, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              PriceChangeHelper.formatDailyChange(daily.changeAmount),
              style: TextStyle(color: changeColor, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              NumberFormatter.formatVolume(daily.tradingVolume),
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
