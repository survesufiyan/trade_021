class PriceTick {
  final int paise; // price in paise (₹0.01)
  final int prevPaise;
  final DateTime timestamp;

  PriceTick({required this.paise, required this.prevPaise, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  double get price => paise / 100.0;
  double get prevPrice => prevPaise / 100.0;
  double get change => price - prevPrice;
  double get changePct => prevPaise == 0 ? 0.0 : (change / prevPrice) * 100.0;
}
