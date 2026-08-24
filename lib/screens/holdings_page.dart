import 'package:flutter/material.dart';
import '../models/holding.dart';
import '../services/price_feed.dart';
import '../services/trading_state.dart';
import 'trade_ticket_page.dart';

enum HoldingSort { pnl, symbol, value }

class HoldingsPage extends StatefulWidget {
  const HoldingsPage({super.key});
  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  HoldingSort sort = HoldingSort.pnl;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: TradingState.instance,
      builder: (_, __) {
        final s = TradingState.instance;
        return Scaffold(
            appBar: AppBar(title: const Text('Holdings'), actions: [
              PopupMenuButton<HoldingSort>(
                  onSelected: (v) => setState(() => sort = v),
                  itemBuilder: (_) => HoldingSort.values
                      .map((v) => PopupMenuItem(
                          value: v, child: Text('Sort by ${v.name}')))
                      .toList())
            ]),
            body: s.holdings.isEmpty
                ? const Center(
                    child: Text('No holdings yet. Place a buy order to begin.'))
                : _LiveHoldings(holdings: s.holdings, sort: sort));
      });
}

class _LiveHoldings extends StatelessWidget {
  final List<Holding> holdings;
  final HoldingSort sort;
  const _LiveHoldings({required this.holdings, required this.sort});
  @override
  Widget build(BuildContext context) {
    final merged = Listenable.merge(
        holdings.map((h) => PriceFeed.instance.notifierFor(h.ticker)!));
    return AnimatedBuilder(
        animation: merged,
        builder: (_, __) {
          final rows = [...holdings];
          int pnl(Holding h) =>
              h.qty * (PriceFeed.instance.current(h.ticker).paise - h.avgPaise);
          int value(Holding h) =>
              h.qty * PriceFeed.instance.current(h.ticker).paise;
          rows.sort((a, b) => sort == HoldingSort.symbol
              ? a.ticker.compareTo(b.ticker)
              : sort == HoldingSort.value
                  ? value(b).compareTo(value(a))
                  : pnl(b).compareTo(pnl(a)));
          final invested = rows.fold<int>(0, (a, h) => a + h.qty * h.avgPaise);
          final current = rows.fold<int>(0, (a, h) => a + value(h));
          return Column(children: [
            Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(16),
                child: Wrap(spacing: 28, runSpacing: 8, children: [
                  _metric('Invested', invested),
                  _metric('Current', current),
                  _metric('Total P&L', current - invested,
                      pct: invested == 0
                          ? 0
                          : (current - invested) * 100 / invested)
                ])),
            Expanded(
                child: ListView.separated(
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final h = rows[i],
                          tick = PriceFeed.instance.current(h.ticker),
                          profit = pnl(h),
                          pct = (tick.paise - h.avgPaise) * 100 / h.avgPaise;
                      return ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      TradeTicketPage(symbol: h.ticker))),
                          title: Text('${h.ticker}  ·  ${h.qty} qty'),
                          subtitle: Text(
                              'Avg ₹${(h.avgPaise / 100).toStringAsFixed(2)}  •  LTP ₹${tick.price.toStringAsFixed(2)}\nValue ₹${(value(h) / 100).toStringAsFixed(2)}'),
                          isThreeLine: true,
                          trailing: Text(
                              '${profit >= 0 ? '+' : ''}₹${(profit / 100).toStringAsFixed(2)}\n${pct.toStringAsFixed(2)}%',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color:
                                      profit >= 0 ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600)));
                    }))
          ]);
        });
  }

  Widget _metric(String label, int paise, {double? pct}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(
            '₹${(paise / 100).toStringAsFixed(2)}${pct == null ? '' : ' (${pct.toStringAsFixed(2)}%)'}',
            style: const TextStyle(fontWeight: FontWeight.bold))
      ]);
}
