import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/holding.dart';
import '../models/watchlist_model.dart';
import '../data/master_stocks.dart';

class PersistenceService {
  PersistenceService._();
  static final PersistenceService instance = PersistenceService._();

  static const _kWatchlists = 'watchlists_v1';
  static const _kHoldings = 'holdings_v1';
  static const _kWallet = 'wallet_paise_v1';
  static const _kOrders = 'orders_v1';

  Future<void> saveWatchlists(List<WatchlistModel> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final data = lists
        .map((w) => {
              'wlId': w.wlId,
              'title': w.title,
              'items': w.items.map((s) => s.tickerName).toList(),
            })
        .toList();
    await prefs.setString(_kWatchlists, jsonEncode(data));
  }

  Future<List<WatchlistModel>?> loadWatchlists() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kWatchlists);
    if (s == null) return null;
    try {
      final decoded = jsonDecode(s) as List<dynamic>;
      return decoded.map((w) {
        final map = w as Map<String, dynamic>;
        final items = (map['items'] as List<dynamic>).map((t) {
          final key = (t as String);
          return MasterStocks.byTicker[key] ??
              MasterStocks.byTicker.values.first;
        }).toList();
        return WatchlistModel(
            wlId: map['wlId'], title: map['title'], items: items.cast());
      }).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveHoldings(List<Holding> holdings) async {
    final prefs = await SharedPreferences.getInstance();
    final data = holdings.map((h) => h.toJson()).toList();
    await prefs.setString(_kHoldings, jsonEncode(data));
  }

  Future<List<Holding>> loadHoldings() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kHoldings);
    if (s == null) return [];
    try {
      final decoded = jsonDecode(s) as List<dynamic>;
      return decoded
          .map((j) => Holding.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveWallet(int paise) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWallet, paise);
  }

  Future<int> loadWallet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWallet) ?? 10000000;
  }

  Future<void> saveOrders(List<Map<String, dynamic>> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kOrders, jsonEncode(orders));
  }

  Future<List<Map<String, dynamic>>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kOrders);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
