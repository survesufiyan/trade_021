import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/index_ticker.dart';
import '../../models/stock_item.dart';
import '../../models/watchlist_model.dart';
import '../../repository/watchlist_data_source.dart';
import '../../services/persistence_service.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(const WatchlistLoadingState()) {
    on<FetchWatchlistData>(_handleFetch);
    on<SwitchWatchlistTab>(_handleTabSwitch);
    on<StartEditingWatchlist>(_handleEditStart);
    on<CancelWatchlistEdit>(_handleEditCancel);
    on<ReorderStockInList>(_handleReorder);
    on<DeleteStockFromEdit>(_handleDelete);
    on<SaveWatchlistEdits>(_handleSave);
  }

  Future<void> _handleFetch(
      FetchWatchlistData event, Emitter<WatchlistState> emit) async {
    final indices = WatchlistDataSource.headerIndices;
    try {
      final persisted = await PersistenceService.instance.loadWatchlists();
      final watchlists = persisted ?? WatchlistDataSource.defaultWatchlists;
      emit(WatchlistReadyState(
        allWatchlists: watchlists,
        indices: indices,
        activeTab: 0,
      ));
    } catch (e) {
      final watchlists = WatchlistDataSource.defaultWatchlists;
      emit(WatchlistReadyState(
          allWatchlists: watchlists, indices: indices, activeTab: 0));
    }
  }

  void _handleTabSwitch(
      SwitchWatchlistTab event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistReadyState) return;
    final curr = state as WatchlistReadyState;
    emit(curr.copyWith(activeTab: event.index));
  }

  void _handleEditStart(
      StartEditingWatchlist event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistReadyState) return;
    final curr = state as WatchlistReadyState;

    // copy current stocks into pending so we can freely mutate without touching originals
    final draftCopy = List<StockItem>.from(curr.currentWatchlist.items);

    emit(WatchlistEditingState(
      allWatchlists: curr.allWatchlists,
      indices: curr.indices,
      activeTab: curr.activeTab,
      pendingItems: draftCopy,
    ));
  }

  void _handleEditCancel(
      CancelWatchlistEdit event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistEditingState) return;
    final curr = state as WatchlistEditingState;

    // just go back to ready, draft is discarded automatically
    emit(WatchlistReadyState(
      allWatchlists: curr.allWatchlists,
      indices: curr.indices,
      activeTab: curr.activeTab,
    ));
  }

  void _handleReorder(ReorderStockInList event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistEditingState) return;
    final curr = state as WatchlistEditingState;

    final updated = List<StockItem>.from(curr.pendingItems);
    int dest = event.toIndex;

    // flutter's ReorderableListView passes newIndex after removal,
    // so we subtract 1 if moving downward
    if (dest > event.fromIndex) dest -= 1;

    final moved = updated.removeAt(event.fromIndex);
    updated.insert(dest, moved);

    emit(curr.copyWith(pendingItems: updated));
  }

  void _handleDelete(DeleteStockFromEdit event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistEditingState) return;
    final curr = state as WatchlistEditingState;

    final updated =
        curr.pendingItems.where((s) => s.uid != event.stockUid).toList();
    emit(curr.copyWith(pendingItems: updated));
  }

  void _handleSave(SaveWatchlistEdits event, Emitter<WatchlistState> emit) {
    if (state is! WatchlistEditingState) return;
    final curr = state as WatchlistEditingState;

    // write pending back into the watchlist list
    final updatedLists = List<WatchlistModel>.from(curr.allWatchlists);
    updatedLists[curr.activeTab] = curr.currentWatchlist.copyWith(
      items: List<StockItem>.from(curr.pendingItems),
    );

    emit(WatchlistReadyState(
      allWatchlists: updatedLists,
      indices: curr.indices,
      activeTab: curr.activeTab,
    ));
  }
}
