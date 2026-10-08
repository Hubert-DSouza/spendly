import 'package:expense_tracker/constants/app_constants.dart';
import 'package:expense_tracker/models/savings.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/savings_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SavingsTile extends ConsumerWidget {
  final SavingsModel savingsGoal;

  const SavingsTile({super.key, required this.savingsGoal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  savingsGoal.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "₹${savingsGoal.targetAmount.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xs),

            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  const TextSpan(text: 'Save '),
                  TextSpan(
                    text:
                        '₹${ref.read(savingsProvider.notifier).toSavePerDay(savingsGoal).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' per day for '),
                  TextSpan(
                    text: ref
                        .read(savingsProvider.notifier)
                        .daysTillTarget(savingsGoal)
                        .toStringAsFixed(0),
                  ),
                  const TextSpan(text: ' days.'),
                ],
              ),
            ),

            Row(
              children: [
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(savingsGoal.date).toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        
                        return AlertDialog(
                          title: Text('Delete Savings'),
                          content: Text(
                            'Are you sure you want to delete this savings?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {                               
                                Navigator.pop(context);
                                ref
                                    .read(savingsProvider.notifier)
                                    .removeSavings(savingsGoal.id!);
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete, size: 18, color: AppColors.danger),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
