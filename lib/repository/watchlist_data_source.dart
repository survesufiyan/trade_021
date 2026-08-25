import '../models/index_ticker.dart';
import '../models/watchlist_model.dart';
import '../data/master_stocks.dart';

class WatchlistDataSource {
  static List<IndexTicker> get headerIndices => [
        IndexTicker(
          label: 'SENSEX 18TH SEP 8...',
          exchangeName: 'BSE',
          value: 1225.55,
          chg: 144.50,
          chgPct: 13.35,
        ),
        IndexTicker(
          label: 'NIFTY BANK',
          exchangeName: 'NSE',
          value: 54174.45,
          chg: -12.45,
          chgPct: -0.02,
        ),
      ];

  static List<WatchlistModel> get defaultWatchlists => [
        WatchlistModel(
          wlId: 'wl_1',
          title: 'My Watchlist',
          items: [
            MasterStocks.byTicker['RELIANCE']!,
            MasterStocks.byTicker['TCS']!,
            MasterStocks.byTicker['INFY']!,
          ],
        ),
        WatchlistModel(
          wlId: 'wl_2',
          title: 'Tech & Banks',
          items: [
            MasterStocks.byTicker['HDFCBANK']!,
            MasterStocks.byTicker['ICICIBANK']!,
            MasterStocks.byTicker['AXISBANK']!,
          ],
        ),
      ];
}
