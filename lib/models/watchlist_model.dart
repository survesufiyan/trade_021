import 'package:equatable/equatable.dart';
import 'stock_item.dart';

class WatchlistModel extends Equatable {
  final String wlId;
  final String title;
  final List<StockItem> items;

  const WatchlistModel({
    required this.wlId,
    required this.title,
    required this.items,
  });

  WatchlistModel copyWith(
      {String? wlId, String? title, List<StockItem>? items}) {
    return WatchlistModel(
      wlId: wlId ?? this.wlId,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [wlId, title, items];
}
