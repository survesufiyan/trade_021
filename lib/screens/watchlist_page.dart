import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/watchlist/watchlist_bloc.dart';
import '../constants/app_colors.dart';
import '../widgets/index_ticker_card.dart';
import '../widgets/stock_row.dart';
import '../widgets/trade_bottom_nav.dart';
import 'edit_watchlist_page.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(const FetchWatchlistData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (ctx, state) {
        if (state is WatchlistLoadingState) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is! WatchlistReadyState) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderStrip(state),
                _buildSearchField(),
                _buildTabRow(ctx, state),
                const Divider(height: 1, color: AppColors.strokeLight),
                _buildSortButton(ctx),
                const Divider(height: 1, color: AppColors.strokeLight),
                Expanded(
                  child: state.currentWatchlist.items.isEmpty
                      ? const Center(
                          child: Text('Nothing here yet', style: TextStyle(color: AppColors.textMuted)),
                        )
                      : ListView.builder(
                          itemCount: state.currentWatchlist.items.length,
                          itemBuilder: (_, i) => StockRow(stock: state.currentWatchlist.items[i]),
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const TradeBottomNav(),
        );
      },
    );
  }

  Widget _buildHeaderStrip(WatchlistReadyState state) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.strokeLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: state.indices.isNotEmpty
                ? IndexTickerCard(data: state.indices[0])
                : const SizedBox.shrink(),
          ),
          Container(width: 1, height: 36, color: AppColors.strokeLight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: state.indices.length > 1
                  ? IndexTickerCard(data: state.indices[1], showArrow: true)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.search, color: AppColors.textMuted, size: 19),
            SizedBox(width: 7),
            Text('Search for instruments', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabRow(BuildContext ctx, WatchlistReadyState state) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: state.allWatchlists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, i) {
          final isSelected = i == state.activeTab;
          return GestureDetector(
            onTap: () => ctx.read<WatchlistBloc>().add(SwitchWatchlistTab(i)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.allWatchlists[i].title,
                  style: isSelected ? AppTextStyles.tabActive : AppTextStyles.tabInactive,
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  width: isSelected ? 56 : 0,
                  decoration: BoxDecoration(
                    color: AppColors.textDark,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToEditPage(BuildContext ctx) {
    ctx.read<WatchlistBloc>().add(const StartEditingWatchlist());
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: ctx.read<WatchlistBloc>(),
          child: const EditWatchlistPage(),
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      child: GestureDetector(
        onTap: () => _goToEditPage(ctx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.strokeLight),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 15, color: AppColors.textDark),
              SizedBox(width: 5),
              Text('Sort by', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
            ],
          ),
        ),
      ),
    );
  }
}
