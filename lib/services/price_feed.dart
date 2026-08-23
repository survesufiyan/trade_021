import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../models/price_tick.dart';

class PriceFeed {
  PriceFeed._internal() {
    _init();
  }

  static final PriceFeed instance = PriceFeed._internal();

  final Map<String, ValueNotifier<PriceTick>> _notifiers = {};
  final Map<String, int> _prices = {};
  final Random _rng = Random();

  // ticks per second per stock (can be adjusted in debug)
  int ticksPerSec = 1;

  Timer? _timer;

  void _init() {
    // initial prices (in paise)
    final initial = {
      'RELIANCE': 137410,
      'TCS': 345675,
      'INFY': 154230,
      'HDFCBANK': 96695,
      'ICICIBANK': 98050,
      'SBIN': 5250,
      'ITC': 3450,
      'LT': 243850,
      'BHARTIARTL': 8250,
      'AXISBANK': 82500,
    };

    initial.forEach((k, v) {
      _prices[k] = v;
      _notifiers[k] = ValueNotifier(PriceTick(paise: v, prevPaise: v));
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final periodMs = 200; // tick driver period
    _timer = Timer.periodic(Duration(milliseconds: periodMs),
        (_) => _onDriverTick(periodMs / 1000.0));
  }

  void setTickRate(int perSecond) {
    ticksPerSec = perSecond.clamp(0, 20);
  }

  void _onDriverTick(double dtSeconds) {
    final prob =
        ticksPerSec * dtSeconds; // expected updates per stock this tick
    _prices.keys.forEach((sym) {
      if (_rng.nextDouble() <= prob) {
        _doUpdate(sym);
      }
    });
  }

  void _doUpdate(String sym) {
    final cur = _prices[sym]!;
    // random walk - up to +/- 0.5% per tick
    final pct = (_rng.nextDouble() - 0.5) * 0.01; // -0.5%..+0.5%
    final next = max(1, (cur * (1 + pct)).round());
    _prices[sym] = next;
    final tick = PriceTick(paise: next, prevPaise: cur);
    final notifier = _notifiers[sym];
    if (notifier != null) notifier.value = tick;
  }

  ValueNotifier<PriceTick>? notifierFor(String symbol) => _notifiers[symbol];

  List<String> get symbols => _notifiers.keys.toList(growable: false);

  void dispose() {
    _timer?.cancel();
    _notifiers.values.forEach((n) => n.dispose());
    _notifiers.clear();
  }
}
