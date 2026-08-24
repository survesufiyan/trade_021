import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/index_ticker.dart';

class IndexTickerCard extends StatelessWidget {
  final IndexTicker data;
  final bool showArrow;

  const IndexTickerCard({
    super.key,
    required this.data,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final chgColor = data.isUp ? AppColors.gain : AppColors.loss;
    final signedPct =
        '${data.chgPct >= 0 ? '' : ''}${data.chgPct.toStringAsFixed(2)}...';
    final signedChg =
        '${data.chg >= 0 ? '' : ''}${data.chg.toStringAsFixed(2)}';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    data.exchangeName,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    data.value.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '$signedChg ($signedPct)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: chgColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showArrow)
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
      ],
    );
  }
}
