import 'package:flutter/material.dart';
import '../data/master_stocks.dart';
import '../models/watchlist_model.dart';
import '../services/trading_state.dart';
import '../widgets/stock_row.dart';
import 'trade_ticket_page.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});
  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: TradingState.instance,
      builder: (context, _) {
        final s = TradingState.instance;
        if (!s.ready) return const Center(child: CircularProgressIndicator());
        if (selected >= s.watchlists.length) selected = 0;
        final list = s.watchlists[selected];
        return Scaffold(
            appBar: AppBar(title: const Text('Watchlists'), actions: [
              IconButton(
                  tooltip: 'Add watchlist',
                  onPressed: () => _nameDialog(),
                  icon: const Icon(Icons.add)),
              PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'rename') _nameDialog(rename: true);
                    if (v == 'delete') s.deleteWatchlist(selected);
                  },
                  itemBuilder: (_) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(value: 'delete', child: Text('Delete'))
                      ])
            ]),
            body: Column(children: [
              SizedBox(
                  height: 48,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: s.watchlists.length,
                      itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                              label: Text(s.watchlists[i].title),
                              selected: i == selected,
                              onSelected: (_) =>
                                  setState(() => selected = i))))),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(children: [
                    Text('${list.items.length} stocks'),
                    const Spacer(),
                    TextButton.icon(
                        onPressed: () => _pickStocks(list),
                        icon: const Icon(Icons.playlist_add),
                        label: const Text('Add stocks'))
                  ])),
              const Divider(height: 1),
              Expanded(
                  child: list.items.isEmpty
                      ? const Center(
                          child:
                              Text('No stocks yet. Add one to start watching.'))
                      : ReorderableListView.builder(
                          itemCount: list.items.length,
                          // ignore: deprecated_member_use
                          onReorder: (a, b) {
                            final x = [...list.items];
                            if (b > a) b--;
                            final item = x.removeAt(a);
                            x.insert(b, item);
                            s.replaceWatchlist(
                                selected, list.copyWith(items: x));
                          },
                          itemBuilder: (_, i) {
                            final stock = list.items[i];
                            return Dismissible(
                                key: ValueKey('${list.wlId}-${stock.uid}'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.all(20),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white)),
                                onDismissed: (_) {
                                  final x = [...list.items]..removeAt(i);
                                  s.replaceWatchlist(
                                      selected, list.copyWith(items: x));
                                },
                                child: StockRow(
                                    key: ValueKey(stock.uid),
                                    stock: stock,
                                    onTap: () => _ticket(stock.tickerName)));
                          }))
            ]));
      });
  void _ticket(String symbol) => Navigator.push(context,
      MaterialPageRoute(builder: (_) => TradeTicketPage(symbol: symbol)));
  Future<void> _nameDialog({bool rename = false}) async {
    final c = TextEditingController(
        text: rename ? TradingState.instance.watchlists[selected].title : '');
    final name = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
                title: Text(rename ? 'Rename watchlist' : 'New watchlist'),
                content: TextField(controller: c, autofocus: true),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(d, c.text.trim()),
                      child: const Text('Save'))
                ]));
    if (name == null || name.isEmpty) return;
    if (rename) {
      final w = TradingState.instance.watchlists[selected];
      TradingState.instance.replaceWatchlist(selected, w.copyWith(title: name));
    } else {
      TradingState.instance.addWatchlist(name);
      setState(() => selected = TradingState.instance.watchlists.length - 1);
    }
  }

  Future<void> _pickStocks(WatchlistModel list) async {
    final chosen = list.items.map((e) => e.tickerName).toSet();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (b) => StatefulBuilder(
            builder: (b, setSheet) => SafeArea(
                    child: ListView(shrinkWrap: true, children: [
                  const ListTile(
                      title: Text('Choose stocks',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  ...MasterStocks.byTicker.entries.map((e) => CheckboxListTile(
                      value: chosen.contains(e.key),
                      title: Text(e.key),
                      onChanged: (v) {
                        setSheet(() {
                          v! ? chosen.add(e.key) : chosen.remove(e.key);
                        });
                      })),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton(
                          onPressed: () {
                            final items = MasterStocks.byTicker.entries
                                .where((e) => chosen.contains(e.key))
                                .map((e) => e.value)
                                .toList();
                            TradingState.instance.replaceWatchlist(
                                selected, list.copyWith(items: items));
                            Navigator.pop(b);
                          },
                          child: const Text('Done')))
                ]))));
  }
}
