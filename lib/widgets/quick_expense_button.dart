import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/quick_expense.dart';
import '../theme/app_theme.dart';

class QuickExpenseButton extends StatelessWidget {
  final QuickExpense? expense;
  final VoidCallback onTap;

  const QuickExpenseButton({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = expense;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item != null) ...[
                Text(item.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: AppSpacing.xs),
              ] else ...[
                const Icon(Icons.add, size: 20, color: AppColors.muted),
                const SizedBox(height: AppSpacing.xs),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item == null ? 'Add expense' : item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: item == null ? AppColors.muted : AppColors.ink,
                  ),
                ),
              ),
              if (item != null)
                Text(
                  '₹${item.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
