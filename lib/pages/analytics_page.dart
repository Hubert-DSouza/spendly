import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
//import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import 'package:expense_tracker/constants/app_constants.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  //final now = DateTime.now();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final daysPassed = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(transactionProvider);
    Map<String, double> spendingByCategory = <String, double>{};

    int getNumberOfDays() {
      if (selectedMonth ==
          DateTime(DateTime.now().year, DateTime.now().month)) {
        return daysPassed;
      } else {
        return DateTime(selectedMonth.year, selectedMonth.month + 1, 0)
            .difference(DateTime(selectedMonth.year, selectedMonth.month, 1))
            .inDays;
      }
    }

    //get all the monthly categorical expenses
    for (final expense in expenses) {
      if (expense.occurredAt.year == selectedMonth.year &&
          expense.occurredAt.month == selectedMonth.month) {
        spendingByCategory[expense.category] =
            (spendingByCategory[expense.category] ?? 0) + expense.amount;
      }
    }

    //get all the monthly transactions
    Map<DateTime, List<TransactionModel>> monthlyTransactions = {};
    for (final expense in expenses) {
      final month = DateTime(expense.occurredAt.year, expense.occurredAt.month);
      if (!monthlyTransactions.containsKey(month)) {
        monthlyTransactions[month] = [];
      }
      monthlyTransactions[month]!.add(expense);
    }

    final months = monthlyTransactions.keys.toList();
    //sorting by latest first
    months.sort((a, b) => b.compareTo(a));

    final sections = <PieChartSectionData>[];

    for (final entry in spendingByCategory.entries) {
      sections.add(
        PieChartSectionData(
          value: entry.value,
          color: AppConstants.categoryColors[entry.key],
          title: entry.key,
          radius: 100,
        ),
      ); // add a PieChartSectionData here
    }
    final sortedCategories = spendingByCategory.entries.toList();

    sortedCategories.sort((a, b) => b.value.compareTo(a.value));

    final transactions = monthlyTransactions[selectedMonth] ?? [];

    double totalSpent = 0;

    for (final transaction in transactions) {
      totalSpent += transaction.amount;
    }

    final averageSpentDaily = totalSpent / getNumberOfDays();

    
    

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Analytics',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Spacer(),
                    DropdownMenu<DateTime>(
                      width: 110,
                      initialSelection: selectedMonth,
                      label: Text(DateFormat('MMM').format(selectedMonth)),
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                      ),

                      onSelected: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedMonth = value;
                        });
                      },
                      dropdownMenuEntries: months.map((month) {
                        return DropdownMenuEntry<DateTime>(
                          value: month,
                          label: DateFormat('MMM').format(month),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                spendingByCategory.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Text(
                          'No expenses yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 220,
                              child: PieChart(
                                PieChartData(
                                  sections: sections,
                                  centerSpaceRadius: 0,
                                ),
                              ),
                            ),

                            SizedBox(height: AppSpacing.xl),

                            Text(
                              "Spending by Category: ",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),

                            SizedBox(height: AppSpacing.md),

                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: spendingByCategory.length >= 5
                                    ? 5
                                    : spendingByCategory.length,
                                itemBuilder: (context, index) {
                                  final entry = sortedCategories[index];

                                  final category = entry.key;
                                  final amount = entry.value;

                                  return Row(
                                    children: [
                                      Icon(
                                        AppConstants.getCategoryIcon(category),
                                        color: AppConstants
                                            .categoryColors[category],
                                      ),
                                      SizedBox(width: AppSpacing.md),
                                      Text(
                                        category,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        amount.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: AppSpacing.xl),

                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Avg. Daily Spend",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '₹${averageSpentDaily.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Text(
                                //   "Average spending for ${DateFormat('MMM').format(selectedMonth)}",
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 10,
                                //     fontWeight: FontWeight.w400,
                                //     color: Theme.of(context).colorScheme.onSurfaceVariant,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Monthly Total",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '₹${totalSpent.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Text(
                                //   "Safe to spend today.",
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 10,
                                //     fontWeight: FontWeight.w400,
                                //     color: Theme.of(context).colorScheme.onSurfaceVariant,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Card(
                    //         color: Theme.of(context).scaffoldBackgroundColor,
                    //         elevation: 0,
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               "Today's Limit",
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //               ),
                    //             ),
                    //             Text(
                    //               '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                    //               style: GoogleFonts.poppins(
                    //                 color: Theme.of(context).colorScheme.primary,
                    //                 fontSize: 30,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //             Text(
                    //               "Safe to spend today.",
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 10,
                    //                 fontWeight: FontWeight.w400,
                    //                 color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Card(
                    //         color: Theme.of(context).scaffoldBackgroundColor,
                    //         elevation: 0,
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               "Today's Limit",
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //               ),
                    //             ),
                    //             Text(
                    //               '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                    //               style: GoogleFonts.poppins(
                    //                 color: Theme.of(context).colorScheme.primary,
                    //                 fontSize: 30,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //             Text(
                    //               "Safe to spend today.",
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 10,
                    //                 fontWeight: FontWeight.w400,
                    //                 color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
