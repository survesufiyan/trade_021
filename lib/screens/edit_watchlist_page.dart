import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/watchlist/watchlist_bloc.dart';
import '../constants/app_colors.dart';
import '../models/stock_item.dart';
import '../widgets/editable_stock_row.dart';

class EditWatchlistPage extends StatelessWidget {
  const EditWatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistBloc, WatchlistState>(
      // pop back when save is done
      listenWhen: (prev, next) =>
          prev is WatchlistEditingState && next is WatchlistReadyState,
      listener: (ctx, _) => Navigator.of(ctx).pop(),
      builder: (ctx, state) {
        if (state is! WatchlistEditingState) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return _buildPage(ctx, state);
      },
    );
  }

  Widget _buildPage(BuildContext ctx, WatchlistEditingState state) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            ctx.read<WatchlistBloc>().add(const CancelWatchlistEdit());
            Navigator.of(ctx).pop();
          },
        ),
        title: Text(
          'Edit ${state.currentWatchlist.title}',
          style: AppTextStyles.sectionHeader,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.strokeLight),
          _WatchlistNameField(name: state.currentWatchlist.title),
          const Divider(height: 1, color: AppColors.strokeLight),
          Expanded(
            child: _buildDragList(ctx, state.pendingItems),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(ctx),
    );
  }

  Widget _buildDragList(BuildContext ctx, List<StockItem> items) {
    return ReorderableListView.builder(
      itemCount: items.length,
      // ignore: deprecated_member_use
      onReorder: (from, to) {
        ctx
            .read<WatchlistBloc>()
            .add(ReorderStockInList(fromIndex: from, toIndex: to));
      },
      proxyDecorator: (child, idx, anim) {
        return AnimatedBuilder(
          animation: anim,
          builder: (_, ch) =>
              Material(elevation: 3, shadowColor: Colors.black12, child: ch),
          child: child,
        );
      },
      itemBuilder: (_, i) {
        final s = items[i];
        return EditableStockRow(
          key: ValueKey(s.uid),
          stock: s,
          listIndex: i,
          onRemove: () =>
              ctx.read<WatchlistBloc>().add(DeleteStockFromEdit(s.uid)),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext ctx) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {}, // placeholder for other watchlists editing
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.strokeLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: const Text(
                  'Edit other watchlists',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark),
                ),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () =>
                    ctx.read<WatchlistBloc>().add(const SaveWatchlistEdits()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textDark,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: const Text(
                  'Save Watchlist',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistNameField extends StatelessWidget {
  final String name;
  const _WatchlistNameField({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textDark))),
          const Icon(Icons.edit_outlined, size: 17, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
