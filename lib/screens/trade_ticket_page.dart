import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/price_tick.dart';
import '../services/price_feed.dart';
import '../services/trading_state.dart';

class TradeTicketPage extends StatefulWidget {
  final String symbol;
  const TradeTicketPage({super.key, required this.symbol});
  @override
  State<TradeTicketPage> createState() => _TradeTicketPageState();
}

class _TradeTicketPageState extends State<TradeTicketPage> {
  bool buy = true;
  final qty = TextEditingController();
  String? error;
  @override
  void dispose() {
    qty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = PriceFeed.instance.notifierFor(widget.symbol)!;
    return Scaffold(
        appBar: AppBar(title: Text(widget.symbol)),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<bool>(segments: const [
                    ButtonSegment(value: true, label: Text('Buy')),
                    ButtonSegment(value: false, label: Text('Sell'))
                  ], selected: {
                    buy
                  }, onSelectionChanged: (v) => setState(() => buy = v.first)),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<PriceTick>(
                      valueListenable: notifier,
                      builder: (_, tick, __) {
                        final q = int.tryParse(qty.text) ?? 0;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Live LTP  ₹${tick.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: 6),
                              Text(
                                  'Projected value  ₹${(q * tick.paise / 100).toStringAsFixed(2)}')
                            ]);
                      }),
                  const SizedBox(height: 24),
                  TextField(
                      controller: qty,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => setState(() => error = null),
                      decoration: InputDecoration(
                          labelText: 'Quantity',
                          errorText: error,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                      animation: TradingState.instance,
                      builder: (_, __) => Text(
                          'Available balance: ₹${(TradingState.instance.walletPaise / 100).toStringAsFixed(2)}')),
                  const Spacer(),
                  FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                          backgroundColor: buy ? Colors.green : Colors.red,
                          padding: const EdgeInsets.all(16)),
                      child: Text('${buy ? 'Buy' : 'Sell'} ${widget.symbol}'))
                ])));
  }

  void _submit() {
    final q = int.tryParse(qty.text);
    if (q == null || q <= 0) {
      setState(() => error = 'Enter a positive whole quantity');
      return;
    }
    final result = TradingState.instance.placeOrder(widget.symbol, buy, q);
    if (result != null) {
      setState(() => error = result);
      return;
    }
    final execution = TradingState.instance.orders.first;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (confirmationContext) => Scaffold(
            appBar: AppBar(title: const Text('Order confirmed')),
            body: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 72),
              const SizedBox(height: 16),
              Text('${buy ? 'Bought' : 'Sold'} $q ${widget.symbol}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(
                  'Executed at ₹${(execution.pricePaise / 100).toStringAsFixed(2)}'),
              const SizedBox(height: 24),
              FilledButton(
                      onPressed: () => Navigator.pop(confirmationContext),
                  child: const Text('Done'))
            ])))));
  }
}
