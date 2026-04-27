import 'package:equatable/equatable.dart';

// exchange types we support right now
enum Exchange { nse, bse, idx }

// renamed from 'index' to 'idx' because Dart enums already have a built-in .index property
// that caused a conflict - learned this the hard way
enum SegmentType { equity, monthly, idx }

class StockItem extends Equatable {
  final String uid;
  final String tickerName;
  final Exchange exchange;
  final SegmentType segment;
  final double ltp; // last traded price
  final double dayChange;
  final double dayChangePct;

  const StockItem({
    required this.uid,
    required this.tickerName,
    required this.exchange,
    required this.segment,
    required this.ltp,
    required this.dayChange,
    required this.dayChangePct,
  });

  bool get gainToday => dayChange >= 0;

  // e.g. "NSE | EQ" or "NSE | Monthly"
  String get exchangeSegmentLabel {
    final ex = exchange.name.toUpperCase();
    if (segment == SegmentType.idx) return ex;
    if (segment == SegmentType.monthly) return '$ex | Monthly';
    return '$ex | EQ';
  }

  String formattedLtp() {
    // indian number format for large values like MRF
    if (ltp >= 1000) {
      final str = ltp.toStringAsFixed(2);
      final dotIdx = str.indexOf('.');
      String intStr = str.substring(0, dotIdx);
      final decStr = str.substring(dotIdx);

      if (intStr.length > 3) {
        final lastThree = intStr.substring(intStr.length - 3);
        String remaining = intStr.substring(0, intStr.length - 3);
        final buf = StringBuffer();
        int count = 0;
        for (int i = remaining.length - 1; i >= 0; i--) {
          buf.write(remaining[i]);
          count++;
          if (count == 2 && i != 0) {
            buf.write(',');
            count = 0;
          }
        }
        remaining = buf.toString().split('').reversed.join();
        intStr = '$remaining,$lastThree';
      }
      return '$intStr$decStr';
    }
    return ltp.toStringAsFixed(2);
  }

  String formattedChange() {
    if (dayChange == 0 && dayChangePct == 0) return '0.00 (0.00%)';
    final absPct = dayChangePct.abs().toStringAsFixed(2);
    final absChange = dayChange.abs().toStringAsFixed(2);
    return '$absChange ($absPct%)';
  }

  StockItem copyWith({
    String? uid,
    String? tickerName,
    Exchange? exchange,
    SegmentType? segment,
    double? ltp,
    double? dayChange,
    double? dayChangePct,
  }) {
    return StockItem(
      uid: uid ?? this.uid,
      tickerName: tickerName ?? this.tickerName,
      exchange: exchange ?? this.exchange,
      segment: segment ?? this.segment,
      ltp: ltp ?? this.ltp,
      dayChange: dayChange ?? this.dayChange,
      dayChangePct: dayChangePct ?? this.dayChangePct,
    );
  }

  @override
  List<Object?> get props => [uid, tickerName, exchange, segment, ltp, dayChange, dayChangePct];
}
