import 'package:flutter/material.dart';

// keeping all colours in one place so its easier to theme later
class AppColors {
  AppColors._();

  static const Color brand = Color(0xFF387ED1);

  static const Color gain = Color(0xFF1DB954);
  static const Color loss = Color(0xFFE5484D);

  static const Color textDark = Color(0xFF111111);
  static const Color textMuted = Color(0xFF8A8A8A);
  static const Color strokeLight = Color(0xFFE4E4E4);
  static const Color bgGrey = Color(0xFFF3F3F3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color handleGrey = Color(0xFFAAAAAA);
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle tickerSymbol = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.1,
  );

  static const TextStyle tickerSubtitle = TextStyle(
    fontSize: 11,
    color: AppColors.textMuted,
  );

  static const TextStyle priceLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle changeLabel = TextStyle(
    fontSize: 11,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle tabActive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle tabInactive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle editStockName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );
}
