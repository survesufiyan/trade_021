import 'package:flutter/material.dart';
import '../data/master_stocks.dart';
import '../services/price_feed.dart';
import '../widgets/stock_row.dart';
import 'trade_ticket_page.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Live market'), actions: [
        PopupMenuButton<int>(
            tooltip: 'Tick rate',
            onSelected: PriceFeed.instance.setTickRate,
            itemBuilder: (_) => const [
                  PopupMenuItem(value: 1, child: Text('Normal · 1 tick/sec')),
                  PopupMenuItem(value: 5, child: Text('Stress · 5 ticks/sec'))
                ])
      ]),
      body: ListView(
          children: MasterStocks.byTicker.values
              .map((s) => StockRow(
                  key: ValueKey(s.uid),
                  stock: s,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              TradeTicketPage(symbol: s.tickerName)))))
              .toList()));
}
