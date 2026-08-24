import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TradeBottomNav extends StatelessWidget {
  const TradeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // only watchlist tab is active for now, rest are placeholders
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.strokeLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.brand,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border_rounded), label: 'Watchlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_rounded), label: 'GTT+'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded), label: 'Portfolio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Funds'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
