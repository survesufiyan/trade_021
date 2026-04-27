part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

// fired on screen init
class FetchWatchlistData extends WatchlistEvent {
  const FetchWatchlistData();
}

class SwitchWatchlistTab extends WatchlistEvent {
  final int index;
  const SwitchWatchlistTab(this.index);

  @override
  List<Object?> get props => [index];
}

class StartEditingWatchlist extends WatchlistEvent {
  const StartEditingWatchlist();
}

class CancelWatchlistEdit extends WatchlistEvent {
  const CancelWatchlistEdit();
}

// user dropped a stock at a new position
class ReorderStockInList extends WatchlistEvent {
  final int fromIndex;
  final int toIndex;

  const ReorderStockInList({required this.fromIndex, required this.toIndex});

  @override
  List<Object?> get props => [fromIndex, toIndex];
}

class DeleteStockFromEdit extends WatchlistEvent {
  final String stockUid;
  const DeleteStockFromEdit(this.stockUid);

  @override
  List<Object?> get props => [stockUid];
}

class SaveWatchlistEdits extends WatchlistEvent {
  const SaveWatchlistEdits();
}
