// simple model for the market index strip at the top

class IndexTicker {
  final String label;
  final String exchangeName;
  final double value;
  final double chg;
  final double chgPct;

  IndexTicker({
    required this.label,
    required this.exchangeName,
    required this.value,
    required this.chg,
    required this.chgPct,
  });

  bool get isUp => chg >= 0;
}
