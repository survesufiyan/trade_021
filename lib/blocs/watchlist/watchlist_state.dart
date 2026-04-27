part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistLoadingState extends WatchlistState {
  const WatchlistLoadingState();
}

// normal view - tabs, stock list etc
class WatchlistReadyState extends WatchlistState {
  final List<WatchlistModel> allWatchlists;
  final List<IndexTicker> indices;
  final int activeTab;

  const WatchlistReadyState({
    required this.allWatchlists,
    required this.indices,
    required this.activeTab,
  });

  WatchlistModel get currentWatchlist => allWatchlists[activeTab];

  WatchlistReadyState copyWith({
    List<WatchlistModel>? allWatchlists,
    List<IndexTicker>? indices,
    int? activeTab,
  }) {
    return WatchlistReadyState(
      allWatchlists: allWatchlists ?? this.allWatchlists,
      indices: indices ?? this.indices,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [allWatchlists, indices, activeTab];
}

// user tapped edit - we keep a working copy (pendingItems) separate
// from the real data so cancel works properly
class WatchlistEditingState extends WatchlistState {
  final List<WatchlistModel> allWatchlists;
  final List<IndexTicker> indices;
  final int activeTab;
  final List<StockItem> pendingItems; // draft, not yet saved

  const WatchlistEditingState({
    required this.allWatchlists,
    required this.indices,
    required this.activeTab,
    required this.pendingItems,
  });

  WatchlistModel get currentWatchlist => allWatchlists[activeTab];

  WatchlistEditingState copyWith({
    List<WatchlistModel>? allWatchlists,
    List<IndexTicker>? indices,
    int? activeTab,
    List<StockItem>? pendingItems,
  }) {
    return WatchlistEditingState(
      allWatchlists: allWatchlists ?? this.allWatchlists,
      indices: indices ?? this.indices,
      activeTab: activeTab ?? this.activeTab,
      pendingItems: pendingItems ?? this.pendingItems,
    );
  }

  @override
  List<Object?> get props => [allWatchlists, indices, activeTab, pendingItems];
}
