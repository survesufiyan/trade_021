import '../models/index_ticker.dart';
import '../models/stock_item.dart';
import '../models/watchlist_model.dart';

// hardcoded sample data for the interview task
// in real app this would come from an API / websocket

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
          title: 'Watchlist 1',
          items: _watchlist1Items,
        ),
        WatchlistModel(
          wlId: 'wl_5',
          title: 'Watchlist 5',
          items: _watchlist5Items,
        ),
        WatchlistModel(
          wlId: 'wl_6',
          title: 'Watchlist 6',
          items: _watchlist6Items,
        ),
      ];

  static const List<StockItem> _watchlist1Items = [
    StockItem(
      uid: 'RELIANCE_NSE_EQ',
      tickerName: 'RELIANCE',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 1374.10,
      dayChange: -4.40,
      dayChangePct: -0.32,
    ),
    StockItem(
      uid: 'HDFCBANK_NSE_EQ',
      tickerName: 'HDFCBANK',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 966.95,
      dayChange: 0.95,
      dayChangePct: 0.10,
    ),
    StockItem(
      uid: 'ASIANPAINT_NSE_EQ',
      tickerName: 'ASIANPAINT',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 2537.40,
      dayChange: 6.60,
      dayChangePct: 0.26,
    ),
    StockItem(
      uid: 'NIFTYIT_IDX',
      tickerName: 'NIFTY IT',
      exchange: Exchange.idx,
      segment: SegmentType.idx,
      ltp: 35185.35,
      dayChange: 874.91,
      dayChangePct: 2.55,
    ),
    StockItem(
      uid: 'RELIANCE_SEP1880_CE',
      tickerName: 'RELIANCE SEP 1880 CE',
      exchange: Exchange.nse,
      segment: SegmentType.monthly,
      ltp: 0.00,
      dayChange: 0.00,
      dayChangePct: 0.00,
    ),
    StockItem(
      uid: 'RELIANCE_SEP1370_PE',
      tickerName: 'RELIANCE SEP 1370 PE',
      exchange: Exchange.nse,
      segment: SegmentType.monthly,
      ltp: 19.20,
      dayChange: 1.00,
      dayChangePct: 5.49,
    ),
    StockItem(
      uid: 'MRF_NSE_EQ',
      tickerName: 'MRF',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 147625.00,
      dayChange: 550.00,
      dayChangePct: 0.37,
    ),
    StockItem(
      uid: 'MRF_BSE_EQ',
      tickerName: 'MRF',
      exchange: Exchange.bse,
      segment: SegmentType.equity,
      ltp: 147439.45,
      dayChange: 463.80,
      dayChangePct: 0.32,
    ),
  ];

  static const List<StockItem> _watchlist5Items = [
    StockItem(
      uid: 'TCS_NSE_EQ',
      tickerName: 'TCS',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 3456.75,
      dayChange: 23.50,
      dayChangePct: 0.68,
    ),
    StockItem(
      uid: 'INFY_NSE_EQ',
      tickerName: 'INFY',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 1542.30,
      dayChange: -8.20,
      dayChangePct: -0.53,
    ),
    StockItem(
      uid: 'WIPRO_NSE_EQ',
      tickerName: 'WIPRO',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 421.15,
      dayChange: 3.45,
      dayChangePct: 0.83,
    ),
  ];

  static const List<StockItem> _watchlist6Items = [
    StockItem(
      uid: 'TATAMOTORS_NSE_EQ',
      tickerName: 'TATAMOTORS',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 654.80,
      dayChange: 12.35,
      dayChangePct: 1.92,
    ),
    StockItem(
      uid: 'MARUTI_NSE_EQ',
      tickerName: 'MARUTI',
      exchange: Exchange.nse,
      segment: SegmentType.equity,
      ltp: 10234.50,
      dayChange: -45.60,
      dayChangePct: -0.44,
    ),
  ];
}
