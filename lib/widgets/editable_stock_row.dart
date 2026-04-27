import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/stock_item.dart';

// row shown when user is in edit/reorder mode
class EditableStockRow extends StatelessWidget {
  final StockItem stock;
  final int listIndex;
  final VoidCallback onRemove;

  const EditableStockRow({
    super.key,
    required this.stock,
    required this.listIndex,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: listIndex,
                child: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(Icons.drag_handle_rounded, color: AppColors.handleGrey, size: 22),
                ),
              ),
              Expanded(
                child: Text(stock.tickerName, style: AppTextStyles.editStockName),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.delete_outline_rounded, color: AppColors.textDark, size: 21),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.strokeLight),
      ],
    );
  }
}
