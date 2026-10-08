import 'package:expense_tracker/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/transaction.dart';

import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class ExpenseHistory extends ConsumerWidget {
  const ExpenseHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    // grouping Transactions by months
    Map<String, List<TransactionModel>> groupedTransactions = {};
    for (final transaction in transactions) {
      final month = DateFormat('MMMM yyyy').format(transaction.occurredAt);
      if (!groupedTransactions.containsKey(month)) {
        groupedTransactions[month] = [];
      }
      groupedTransactions[month]!.add(transaction);
    }
    // getting all the months
    final months = groupedTransactions.keys.toList();
    months.sort((a, b) {
      final dateA = DateFormat('MMMM yyyy').parse(a);
      final dateB = DateFormat('MMMM yyyy').parse(b);

      return dateB.compareTo(dateA);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: groupedTransactions.isEmpty
                    ? Center(
                        child: Text(
                          'No expenses logged yet',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedTransactions.length,
                        itemBuilder: (context, index) {
                          final month = months[index];
                          final monthTransactions = groupedTransactions[month]!;                         
                          return Column(
                            children: [
                              Text(
                                month,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              for (final transaction in monthTransactions)
                                ExpenseTile(transaction: transaction),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
