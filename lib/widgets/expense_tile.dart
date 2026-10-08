import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class ExpenseTile extends ConsumerWidget {
  final TransactionModel transaction;

  const ExpenseTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final icon = AppConstants.getCategoryIcon(transaction.category);
    final title = transaction.note?.isNotEmpty == true
        ? transaction.note!
        : transaction.category;
    TransactionModel? tempTransaction;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              // child: IconButton(
              //   onPressed: () async {
              //     final shouldDelete = await showDialog<bool>(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: const Text('Delete expense?'),
              //           content: const Text(
              //             'Are you sure you want to delete this expense?',
              //           ),
              //           actions: [
              //             TextButton(
              //               onPressed: () {
              //                 Navigator.pop(context, false);
              //               },
              //               child: const Text('Cancel'),
              //             ),
              //             TextButton(
              //               onPressed: () {
              //                 Navigator.pop(context, true);
              //               },
              //               child: const Text('Delete'),
              //             ),
              //           ],
              //         );
              //       },
              //     );

              //     if (shouldDelete == true) {
              //       ref
              //           .read(transactionProvider.notifier)
              //           .removeTransaction(transaction.id!);
              //     }
              //   },
              //   icon: const Icon(Icons.delete),
              //   color: AppColors.danger,
              // ),
              child: IconButton(
                color: AppColors.danger,

                onPressed: () async {
                  bool confirmDelete = false;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Delete Transaction"),
                        content: Text("Are you sure you want to delete?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              confirmDelete = false;
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              tempTransaction = TransactionModel(
                                amount: transaction.amount,
                                category: transaction.category,
                                note: transaction.note,
                                id: transaction.id,
                                occurredAt: transaction.occurredAt,
                              );
                              Navigator.pop(context);
                              confirmDelete = true;
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete == true) {
                    ref
                        .read(transactionProvider.notifier)
                        .removeTransaction(transaction.id!);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("Transaction Deleted"),
                      action: SnackBarAction(
                        label: "UNDO",
                        textColor: AppColors.surface,
                        onPressed: () {
                          ref
                              .read(transactionProvider.notifier)
                              .addTransaction(
                                tempTransaction!.amount,
                                tempTransaction!.category,
                                tempTransaction!.note,
                                tempTransaction!.occurredAt,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Transaction Restored"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    transaction.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '-₹${transaction.amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
