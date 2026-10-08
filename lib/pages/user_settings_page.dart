import 'package:expense_tracker/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/user_settings_provider.dart';
import '../theme/app_theme.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import '../providers/transaction_provider.dart';

class UserSettingsPage extends ConsumerStatefulWidget {
  const UserSettingsPage({super.key});

  @override
  ConsumerState<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<UserSettingsPage> {
  late final TextEditingController poolController;

  Map<DateTime, int> spendingPerDay(List<TransactionModel> transactions) {
    Map<DateTime, int> spendingMap = {};
    //normalizing budget

    for (final transaction in transactions) {
      final date = DateTime(
        transaction.occurredAt.year,
        transaction.occurredAt.month,
        transaction.occurredAt.day,
      );
      spendingMap[date] = transaction.amount.round();
    }

    return spendingMap;
  }

  @override
  void initState() {
    super.initState();
    final pool = ref.read(userSettingsProvider);
    poolController = TextEditingController(
      text: pool != null ? pool.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    poolController.dispose();
    super.dispose();
  }

  Future<void> savePool() async {
    final amount = double.tryParse(poolController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    await ref.read(userSettingsProvider.notifier).savePoolAmount(amount);
    //if user has accidentally left the page before await finishes
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pool saved')));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final transactions = ref.watch(transactionProvider);
    final heatMapData = spendingPerDay(transactions);
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day);
    final minDate = maxDate.subtract(const Duration(days: 83));
    //12 weeks history

    final entries = heatMapData.entries.map((entry) {
      return ContributionEntry(entry.key, entry.value.round());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                user?.email ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Monthly budget',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: poolController,
                decoration: InputDecoration(
                  hintText: 'Amount (₹)',
                  prefixIcon: Icon(
                    Icons.currency_rupee_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: savePool,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Update Budget',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text("Spending Activity", style: GoogleFonts.poppins(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w600),),
              const SizedBox(height: AppSpacing.md),

              ContributionHeatmap(
                monthTextStyle: GoogleFonts.poppins(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
                weekdayTextStyle: GoogleFonts.poppins(color: AppColors.muted),
                entries: entries,
                minDate: minDate,
                maxDate: maxDate,
                showMonthLabels: true,
                weekdayLabel: WeekdayLabel.full,
                splittedMonthView: true,
                cellSize: 15,
                cellRadius: AppRadius.md,
                // onCellTap: (date, value) {
                //   final spent = spendingMap[date] ?? 0;

                //   showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: Text(DateFormat('d MMMM yyyy').format(date)),
                //         content: Text('Spent: ₹$spent'),
                //       );
                //     },
                //   );
                // },
                customColorScale: (value) {
                  if (value == 0) {
                    return const Color.fromARGB(255, 132, 255, 0);
                  }

                  final intensity = (value / 500).clamp(0.0, 1.0);

                  return Color.lerp(
                    AppColors.background,
                    AppColors.primary,
                    intensity,
                  )!;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ElevatedButton(
              //   onPressed: () {
              //     ref.read(transactionProvider.notifier).seedDemoData();
              //   },
              //   child: const Text('Generate Demo Data'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     ref.read(transactionProvider.notifier).removeDemoData();
              //   },
              //   child: const Text('Remove Demo Data'),
              // ),

              
              
// ElevatedButton(
//   onPressed: () {
//     ref.read(transactionProvider.notifier).seedDemoData();
//   },
//   child: const Text('Generate Demo Data'),
// ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Log out',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
