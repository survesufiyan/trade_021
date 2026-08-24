import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/home_shell.dart';
import 'services/price_feed.dart';
import 'services/trading_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PriceFeed.instance.setTickRate(2);
  TradingState.instance.load();
  runApp(const Trade021App());
}

class Trade021App extends StatelessWidget {
  const Trade021App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Trade 021',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent)),
      home: const HomeShell());
}
