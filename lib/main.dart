import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/watchlist/watchlist_bloc.dart';
import 'constants/app_colors.dart';
import 'screens/watchlist_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const Trade021App());
}

class Trade021App extends StatelessWidget {
  const Trade021App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistBloc(),
      child: MaterialApp(
        title: '021 Trade',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          dividerColor: AppColors.strokeLight,
        ),
        home: const WatchlistPage(),
      ),
    );
  }
}
