import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

// class ExpenseTile extends ConsumerStatefulWidget {
//   final TransactionModel transaction;

//   const ExpenseTile({super.key, required this.transaction});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {}
// }

class ExpenseTile extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  const ExpenseTile({super.key, required this.transaction});

  @override
  ConsumerState<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends ConsumerState<ExpenseTile> {
  @override
  Widget build(BuildContext context) {
    //final icon = AppConstants.getCategoryIcon(transaction.category);
    final title = widget.transaction.note?.isNotEmpty == true
        ? widget.transaction.note!
        : widget.transaction.category;
    TransactionModel? tempTransaction;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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
              //   color: Theme.of(context).colorScheme.error,
              // ),
              child: IconButton(
                color: Theme.of(context).colorScheme.error,

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
                                amount: widget.transaction.amount,
                                category: widget.transaction.category,
                                note: widget.transaction.note,
                                id: widget.transaction.id,
                                occurredAt: widget.transaction.occurredAt,
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
                    await ref
                        .read(transactionProvider.notifier)
                        .removeTransaction(widget.transaction.id!);
                  
                  if (!mounted) {
                    return;
                  }
                  //ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text("Transaction Deleted"),
                      action: SnackBarAction(
                        label: "UNDO",
                        textColor: AppColors.background,
                        onPressed: () async {
                          await ref
                              .read(transactionProvider.notifier)
                              .addTransaction(
                                tempTransaction!.amount,
                                tempTransaction!.category,
                                tempTransaction!.note,
                                tempTransaction!.occurredAt,
                              );
                               if (!mounted) return;
                              
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
                }},
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
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    widget.transaction.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '-₹${widget.transaction.amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  
  }
}
