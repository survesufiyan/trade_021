import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade021/blocs/watchlist/watchlist_bloc.dart';

void main() {
  group('WatchlistBloc tests', () {
    late WatchlistBloc bloc;

    setUp(() {
      bloc = WatchlistBloc();
    });

    tearDown(() => bloc.close());

    test('initial state should be loading', () {
      expect(bloc.state, isA<WatchlistLoadingState>());
    });

    blocTest<WatchlistBloc, WatchlistState>(
      'FetchWatchlistData should emit ready state',
      build: () => WatchlistBloc(),
      act: (b) => b.add(const FetchWatchlistData()),
      expect: () => [isA<WatchlistReadyState>()],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'tab switching works',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const SwitchWatchlistTab(1));
      },
      verify: (b) {
        final s = b.state as WatchlistReadyState;
        expect(s.activeTab, 1);
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'start editing creates a draft copy',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const StartEditingWatchlist());
      },
      expect: () => [isA<WatchlistReadyState>(), isA<WatchlistEditingState>()],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'reorder changes pendingItems correctly',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const StartEditingWatchlist());
        // move first item to third position
        b.add(const ReorderStockInList(fromIndex: 0, toIndex: 2));
      },
      verify: (b) {
        final s = b.state as WatchlistEditingState;
        // after reorder, item at 0 should be what was originally at index 1
        expect(s.pendingItems[0].uid, 'HDFCBANK_NSE_EQ');
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'delete removes correct stock',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const StartEditingWatchlist());
        b.add(const DeleteStockFromEdit('RELIANCE_NSE_EQ'));
      },
      verify: (b) {
        final s = b.state as WatchlistEditingState;
        expect(s.pendingItems.any((x) => x.uid == 'RELIANCE_NSE_EQ'), false);
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'cancel edit throws away the draft',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const StartEditingWatchlist());
        b.add(const ReorderStockInList(fromIndex: 0, toIndex: 3));
        b.add(const CancelWatchlistEdit());
      },
      verify: (b) {
        // original order should be intact
        final s = b.state as WatchlistReadyState;
        expect(s.currentWatchlist.items.first.uid, 'RELIANCE_NSE_EQ');
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'save persists draft into watchlist',
      build: () => WatchlistBloc(),
      act: (b) {
        b.add(const FetchWatchlistData());
        b.add(const StartEditingWatchlist());
        b.add(const ReorderStockInList(fromIndex: 0, toIndex: 2));
        b.add(const SaveWatchlistEdits());
      },
      verify: (b) {
        final s = b.state as WatchlistReadyState;
        // HDFC should now be first since we moved RELIANCE down
        expect(s.currentWatchlist.items.first.uid, 'HDFCBANK_NSE_EQ');
      },
    );
  });
}
