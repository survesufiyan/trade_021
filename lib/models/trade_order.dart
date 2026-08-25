class TradeOrder {
  final String symbol;
  final bool isBuy;
  final int quantity;
  final int pricePaise;
  final DateTime placedAt;

  const TradeOrder(
      {required this.symbol,
      required this.isBuy,
      required this.quantity,
      required this.pricePaise,
      required this.placedAt});

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'isBuy': isBuy,
        'quantity': quantity,
        'pricePaise': pricePaise,
        'placedAt': placedAt.toIso8601String()
      };
  factory TradeOrder.fromJson(Map<String, dynamic> j) => TradeOrder(
      symbol: j['symbol'],
      isBuy: j['isBuy'],
      quantity: j['quantity'],
      pricePaise: j['pricePaise'],
      placedAt: DateTime.parse(j['placedAt']));
}
