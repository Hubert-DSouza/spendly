import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';
import 'package:expense_tracker/constants/app_constants.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(transactionProvider);
    final spendingByCategory = <String, double>{};
    final today = DateTime.now();

    for (final expense in expenses) {
      if (expense.occurredAt.year == today.year &&
          expense.occurredAt.month == today.month) {
        spendingByCategory[expense.category] =
            (spendingByCategory[expense.category] ?? 0) + expense.amount;
      }
    }

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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                spendingByCategory.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'No expenses yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.muted,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
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
                                color: AppColors.muted,
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
                                  final category = spendingByCategory.keys
                                      .elementAt(index);
                                  final amount = spendingByCategory.values
                                      .elementAt(index);

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
                                          color: AppColors.muted,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        amount.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.muted,
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
                            color: AppColors.background,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Today's Limit",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Safe to spend today.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: Card(
                            color: AppColors.background,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Today's Limit",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Safe to spend today.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: AppColors.background,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Today's Limit",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Safe to spend today.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: AppColors.background,
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Today's Limit",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '₹${ref.read(dashboardProvider.notifier).todaysLimit().toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Safe to spend today.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
