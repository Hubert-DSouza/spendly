import 'package:expense_tracker/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/transaction.dart';

import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class ExpenseHistory extends ConsumerWidget {
  const ExpenseHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    //grouping Transactions by months
    Map<String, List<TransactionModel>> groupedTransactions = {};
    for (final transaction in transactions) {
      final month = DateFormat('MMMM yyyy').format(transaction.occurredAt);
      if (!groupedTransactions.containsKey(month)) {
        groupedTransactions[month] = [];
      }
      groupedTransactions[month]!.add(transaction);
    }
    //getting all the months
    final months = groupedTransactions.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: groupedTransactions.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    final monthTransactions = groupedTransactions[month]!;
                    return Column(
                      children: [
                        Text(
                          month,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
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
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}
