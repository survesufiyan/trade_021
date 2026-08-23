class Holding {
  final String ticker;
  final int qty; // integer quantity
  final int avgPaise;

  Holding({required this.ticker, required this.qty, required this.avgPaise});

  Map<String, dynamic> toJson() => {
        'ticker': ticker,
        'qty': qty,
        'avgPaise': avgPaise,
      };

  static Holding fromJson(Map<String, dynamic> j) => Holding(
        ticker: j['ticker'] as String,
        qty: (j['qty'] as num).toInt(),
        avgPaise: (j['avgPaise'] as num).toInt(),
      );
}
