import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/stock_item.dart';
import '../services/price_feed.dart';
import '../models/price_tick.dart';

class StockRow extends StatelessWidget {
  final StockItem stock;
  final VoidCallback? onTap;

  const StockRow({super.key, required this.stock, this.onTap});

  @override
  Widget build(BuildContext context) {
    final notifier = PriceFeed.instance.notifierFor(stock.tickerName);
    if (notifier == null) {
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
                      Text(stock.exchangeSegmentLabel,
                          style: AppTextStyles.tickerSubtitle),
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
                      style:
                          AppTextStyles.changeLabel.copyWith(color: chgColor),
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

    return InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<PriceTick>(
              valueListenable: notifier,
              builder: (_, tick, __) {
                final chgColor =
                    tick.change >= 0 ? AppColors.gain : AppColors.loss;
                final ltpStr = (tick.price).toStringAsFixed(2);
                final chgStr =
                    '${tick.change.toStringAsFixed(2)} (${tick.changePct.toStringAsFixed(2)}%)';
                final flash = tick.change >= 0
                    ? AppColors.gain.withValues(alpha: .13)
                    : AppColors.loss.withValues(alpha: .13);
                return TweenAnimationBuilder<Color?>(
                  key: ValueKey(tick.timestamp),
                  tween: ColorTween(begin: flash, end: Colors.transparent),
                  duration: const Duration(milliseconds: 450),
                  builder: (_, color, child) => ColoredBox(
                    color: color ?? Colors.transparent,
                    child: child!,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stock.tickerName,
                                  style: AppTextStyles.tickerSymbol),
                              const SizedBox(height: 2),
                              Text(stock.exchangeSegmentLabel,
                                  style: AppTextStyles.tickerSubtitle),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(ltpStr,
                                style: AppTextStyles.priceLabel
                                    .copyWith(color: chgColor)),
                            const SizedBox(height: 2),
                            Text(chgStr,
                                style: AppTextStyles.changeLabel
                                    .copyWith(color: chgColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, color: AppColors.strokeLight),
          ],
        ));
  }
}
