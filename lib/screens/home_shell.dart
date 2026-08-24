import 'package:flutter/material.dart';
import 'holdings_page.dart';
import 'market_page.dart';
import 'orders_page.dart';
import 'watchlist_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final pages = const [
    WatchlistPage(),
    MarketPage(),
    HoldingsPage(),
    OrdersPage()
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Watchlists'),
            NavigationDestination(
                icon: Icon(Icons.show_chart), label: 'Market'),
            NavigationDestination(
                icon: Icon(Icons.work_outline), label: 'Holdings'),
            NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined), label: 'Orders')
          ]));
}
