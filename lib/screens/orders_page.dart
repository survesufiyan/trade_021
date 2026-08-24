import 'package:flutter/material.dart';
import '../services/trading_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: TradingState.instance,
      builder: (_, __) {
        final s = TradingState.instance;
        return Scaffold(
            appBar: AppBar(title: const Text('Orders')),
            body: s.orders.isEmpty
                ? const Center(child: Text('No orders placed yet'))
                : ListView.separated(
                    itemCount: s.orders.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final o = s.orders[i];
                      return ListTile(
                          leading: CircleAvatar(
                              backgroundColor: o.isBuy
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              child: Text(o.isBuy ? 'B' : 'S')),
                          title: Text('${o.symbol} · ${o.quantity} shares'),
                          subtitle: Text(
                              o.placedAt.toLocal().toString().substring(0, 16)),
                          trailing: Text(
                              '₹${(o.pricePaise / 100).toStringAsFixed(2)}'));
                    }));
      });
}
