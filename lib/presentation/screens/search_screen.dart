import 'package:edencrew_assignment_starter/domain/entities/stock_search_result.dart';
import 'package:edencrew_assignment_starter/presentation/providers/search_providers.dart';
import 'package:edencrew_assignment_starter/presentation/screens/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/empty_state.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/favorite_button.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/favorite_toast.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/highlighted_text.dart';
import 'package:edencrew_assignment_starter/presentation/widgets/stock_subtitle.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screen 02 · 검색 — search stocks and toggle favorites.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(dimens.space4),
          child: _SearchField(
            controller: _controller,
            onChanged: (value) =>
                ref.read(searchQueryProvider.notifier).setQuery(value),
            onClear: () {
              _controller.clear();
              ref.read(searchQueryProvider.notifier).clear();
            },
          ),
        ),
        Expanded(
          child: _buildBody(query, resultsAsync),
        ),
      ],
    );
  }

  Widget _buildBody(String query, AsyncValue<List<StockSearchResult>> results) {
    if (query.trim().isEmpty) {
      return const EmptyState(
        icon: Icons.search_rounded,
        title: '종목을 검색해 보세요',
        subtitle: '종목명 또는 종목코드 6자리로 검색하실 수 있습니다.',
      );
    }

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => EmptyState(
        icon: Icons.search_off_rounded,
        title: '검색 결과가 없습니다',
        subtitle: "'$query'와 일치하는 검색 결과를 찾지 못했습니다.",
      ),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: Icons.search_off_rounded,
            title: '검색 결과가 없습니다',
            subtitle: "'$query'와 일치하는 검색 결과를 찾지 못했습니다.",
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: context.colors.borderSubtle,
            indent: context.dimens.space4,
            endIndent: context.dimens.space4,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _SearchResultRow(
              item: item,
              query: query,
              onFavoriteToggled: (added) => FavoriteToast.show(context, added: added),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StockDetailScreen(symbol: item.symbol),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: dimens.space3),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(dimens.radiusLg),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: colors.textTertiary, size: 20),
          SizedBox(width: dimens.space2),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: AppTypography.regular,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '종목명 또는 종목코드',
                hintStyle: TextStyle(color: colors.textTertiary),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: onClear,
                icon: Icon(
                  Icons.close_rounded,
                  color: colors.textTertiary,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.item,
    required this.query,
    required this.onFavoriteToggled,
    required this.onTap,
  });

  final StockSearchResult item;
  final String query;
  final void Function(bool added) onFavoriteToggled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space4,
          vertical: dimens.space3,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightedText(text: item.name, query: query),
                  const SizedBox(height: 4),
                  StockSubtitle(symbol: item.symbol, market: item.market),
                ],
              ),
            ),
            FavoriteButton(
              symbol: item.symbol,
              onToggled: onFavoriteToggled,
            ),
          ],
        ),
      ),
    );
  }
}
