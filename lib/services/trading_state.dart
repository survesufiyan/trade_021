import 'package:flutter/foundation.dart';
import '../models/holding.dart';
import '../models/trade_order.dart';
import '../models/watchlist_model.dart';
import '../repository/watchlist_data_source.dart';
import 'persistence_service.dart';
import 'price_feed.dart';

class TradingState extends ChangeNotifier {
  TradingState._();
  static final instance = TradingState._();
  List<WatchlistModel> watchlists = [];
  List<Holding> holdings = [];
  List<TradeOrder> orders = [];
  int walletPaise = 10000000;
  bool ready = false;

  Future<void> load() async {
    final p = PersistenceService.instance;
    watchlists =
        await p.loadWatchlists() ?? WatchlistDataSource.defaultWatchlists;
    holdings = await p.loadHoldings();
    walletPaise = await p.loadWallet();
    orders = (await p.loadOrders()).map(TradeOrder.fromJson).toList();
    ready = true;
    notifyListeners();
  }

  Future<void> saveWatchlists() =>
      PersistenceService.instance.saveWatchlists(watchlists);
  void replaceWatchlist(int index, WatchlistModel value) {
    watchlists = [...watchlists]..[index] = value;
    saveWatchlists();
    notifyListeners();
  }

  void addWatchlist(String title) {
    watchlists = [
      ...watchlists,
      WatchlistModel(
          wlId: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          items: const [])
    ];
    saveWatchlists();
    notifyListeners();
  }

  void deleteWatchlist(int index) {
    if (watchlists.length == 1) return;
    watchlists = [...watchlists]..removeAt(index);
    saveWatchlists();
    notifyListeners();
  }

  String? placeOrder(String symbol, bool buy, int qty) {
    if (qty <= 0) return 'Quantity must be a positive whole number';
    final price = PriceFeed.instance.current(symbol).paise;
    final value = price * qty;
    final i = holdings.indexWhere((h) => h.ticker == symbol);
    final held = i < 0 ? 0 : holdings[i].qty;
    if (buy && value > walletPaise) return 'Insufficient wallet balance';
    if (!buy && qty > held) return 'You only hold $held shares';
    final next = [...holdings];
    if (buy) {
      walletPaise -= value;
      if (i < 0) {
        next.add(Holding(ticker: symbol, qty: qty, avgPaise: price));
      } else {
        final h = next[i];
        next[i] = Holding(
            ticker: symbol,
            qty: h.qty + qty,
            avgPaise: ((h.avgPaise * h.qty + value) ~/ (h.qty + qty)));
      }
    } else {
      walletPaise += value;
      final h = next[i];
      if (h.qty == qty) {
        next.removeAt(i);
      } else {
        next[i] =
            Holding(ticker: symbol, qty: h.qty - qty, avgPaise: h.avgPaise);
      }
    }
    holdings = next;
    orders = [
      TradeOrder(
          symbol: symbol,
          isBuy: buy,
          quantity: qty,
          pricePaise: price,
          placedAt: DateTime.now()),
      ...orders
    ];
    final p = PersistenceService.instance;
    p.saveHoldings(holdings);
    p.saveWallet(walletPaise);
    p.saveOrders(orders.map((e) => e.toJson()).toList());
    notifyListeners();
    return null;
  }
}
