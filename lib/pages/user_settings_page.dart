import 'package:expense_tracker/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/user_settings_provider.dart';
import '../theme/app_theme.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import '../providers/transaction_provider.dart';
import 'package:expense_tracker/pages/how_to_use_page.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                user?.email ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Monthly budget',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:  BorderSide(color: Theme.of(context).colorScheme.outline),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
              const SizedBox(height: AppSpacing.xl),
              Text("Spending Activity", style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w600),),
              const SizedBox(height: AppSpacing.md),

              ContributionHeatmap(
                monthTextStyle: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                weekdayTextStyle: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10),
                entries: entries,
                minDate: minDate,
                maxDate: maxDate,
                showMonthLabels: true,
                weekdayLabel: WeekdayLabel.full,
                splittedMonthView: true,
                cellSize: 14,
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
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).colorScheme.primary,
                    intensity,
                  )!;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              Row(children: [
                Expanded(child: Column(children: [Icon(Icons.circle, color: const Color.fromARGB(255, 132, 255, 0), size: 20,), Text("₹0 ", style: GoogleFonts.poppins(fontSize: 12),), ],)),
                Expanded(child: Column(children: [Icon(Icons.circle, color: const Color(0xFFBFDBFE), size: 20,), Text("₹1–100 ", style: GoogleFonts.poppins(fontSize: 12),), ],)),
                Expanded(child: Column(children: [Icon(Icons.circle, color: const Color(0xFF60A5FA), size: 20,), Text("₹101–250 ", style: GoogleFonts.poppins(fontSize: 12),), ],)),
                Expanded(child: Column(children: [Icon(Icons.circle, color: const Color.fromARGB(255, 80, 127, 255), size: 20,), Text("₹251–500 ", style: GoogleFonts.poppins(fontSize: 12),), ],)),
                Expanded(child: Column(children: [Icon(Icons.circle, color: const Color.fromARGB(255, 28, 76, 208), size: 20,), Text("₹500+ ", style: GoogleFonts.poppins(fontSize: 12),), ],)),
              ],),

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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HowToUsePage(),
                    ),
                  );
                },
                child: const Text("How to Use Spendly"),
              ),
              SizedBox(height: AppSpacing.sm,),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side:  BorderSide(color: Theme.of(context).colorScheme.outline),
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
