import 'package:flutter_test/flutter_test.dart';
import 'package:trade021/models/holding.dart';
import 'package:trade021/models/price_tick.dart';
import 'package:trade021/models/trade_order.dart';

void main() {
  test('price ticks retain exact paise and direction', () {
    final tick = PriceTick(paise: 12345, prevPaise: 12340);
    expect(tick.price, 123.45);
    expect(tick.change, closeTo(.05, .000001));
    expect(tick.changePct, greaterThan(0));
  });

  test('holdings persistence retains integer money', () {
    final original = Holding(ticker: 'TCS', qty: 7, avgPaise: 345675);
    final restored = Holding.fromJson(original.toJson());
    expect(restored.ticker, 'TCS');
    expect(restored.qty, 7);
    expect(restored.avgPaise, 345675);
  });

  test('orders round-trip through persistence representation', () {
    final time = DateTime.utc(2026, 8, 24, 10, 30);
    final original = TradeOrder(
        symbol: 'INFY',
        isBuy: true,
        quantity: 3,
        pricePaise: 154230,
        placedAt: time);
    final restored = TradeOrder.fromJson(original.toJson());
    expect(restored.symbol, original.symbol);
    expect(restored.pricePaise * restored.quantity, 462690);
    expect(restored.placedAt, time);
  });
}
