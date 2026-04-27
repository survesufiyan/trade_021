import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/stock_item.dart';

class StockRow extends StatelessWidget {
  final StockItem stock;

  const StockRow({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final chgColor = stock.gainToday ? AppColors.gain : AppColors.loss;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.tickerName, style: AppTextStyles.tickerSymbol),
                    const SizedBox(height: 2),
                    Text(stock.exchangeSegmentLabel, style: AppTextStyles.tickerSubtitle),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stock.formattedLtp(),
                    style: AppTextStyles.priceLabel.copyWith(color: chgColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stock.formattedChange(),
                    style: AppTextStyles.changeLabel.copyWith(color: chgColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.strokeLight),
      ],
    );
  }
}
