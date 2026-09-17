import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quick_expense.dart';
import '../models/transaction.dart';
import '../providers/dashboard_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/homepage_tile.dart';
import '../widgets/quick_expense_button.dart';
import 'expense_history.dart';
import 'log_expense_page.dart';
import 'user_settings_page.dart';

int quickExpensesCount = 6;
const String quickExpensesKey = 'quick_expenses';

const List<QuickExpense> defaultQuickExpenses = [
  QuickExpense(name: 'Tea', amount: 20, emoji: '☕', categoryId: 'food'),
  QuickExpense(name: 'Maggi', amount: 40, emoji: '🍜', categoryId: 'food'),
  QuickExpense(name: 'Auto', amount: 50, emoji: '🚗', categoryId: 'transport'),
  QuickExpense(name: 'Laundry', amount: 60, emoji: '🧺', categoryId: 'bills'),
  QuickExpense(name: 'Canteen', amount: 80, emoji: '🍱', categoryId: 'food'),
  QuickExpense(name: 'Coffee', amount: 30, emoji: '☕', categoryId: 'food'),
];

List<QuickExpense> getDefaultQuickExpenses() {
  return List.generate(quickExpensesCount, (i) {
    if (i < defaultQuickExpenses.length) {
      return defaultQuickExpenses[i];
    }
    return QuickExpense(
      name: 'Item ${i + 1}',
      amount: 50,
      emoji: '⚡',
      categoryId: 'other',
    );
  });
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  List<QuickExpense> quickExpenses = getDefaultQuickExpenses();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await ref.read(userSettingsProvider.notifier).loadPoolAmount();
    await ref.read(transactionProvider.notifier).loadTransactions();
    await loadQuickExpenses();
  }

  Future<void> loadQuickExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(quickExpensesKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
        final loaded = list
            .map((e) => QuickExpense.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (loaded.length == quickExpensesCount && mounted) {
          setState(() => quickExpenses = loaded);
          return;
        }
      } catch (_) {}
    }
    await saveQuickExpenses(getDefaultQuickExpenses());
  }

  Future<void> saveQuickExpenses(List<QuickExpense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final data = expenses.map((e) => e.toMap()).toList();
    await prefs.setString(quickExpensesKey, jsonEncode(data));
    if (mounted) {
      setState(() => quickExpenses = List.from(expenses));
    }
  }

  void openLogExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => const LogExpensePage(),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  Future<void> handleQuickExpenseTap(int index) async {
    if (index >= quickExpenses.length) return;
    final expense = quickExpenses[index];
    try {
      await ref
          .read(transactionProvider.notifier)
          .logExpense(
            amount: expense.amount,
            categoryId: expense.categoryId,
            note: expense.name,
            source: TransactionSource.quick,
          );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${expense.name} • ₹${expense.amount.toStringAsFixed(0)} logged',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save expense.')),
        );
      }
    }
  }

  Future<void> openEditQuickExpensesDialog() async {
    final nameControllers = List.generate(
      quickExpensesCount,
      (i) => TextEditingController(
        text: i < quickExpenses.length ? quickExpenses[i].name : '',
      ),
    );
    final emojiControllers = List.generate(
      quickExpensesCount,
      (i) => TextEditingController(
        text: i < quickExpenses.length ? quickExpenses[i].emoji : '⚡',
      ),
    );
    final amountControllers = List.generate(
      quickExpensesCount,
      (i) => TextEditingController(
        text: i < quickExpenses.length
            ? quickExpenses[i].amount.toStringAsFixed(0)
            : '0',
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Quick Expenses',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                for (int i = 0; i < quickExpensesCount; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: TextField(
                            controller: emojiControllers[i],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Emoji',
                              isDense: true,
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: nameControllers[i],
                            decoration: InputDecoration(
                              hintText: 'Name',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: amountControllers[i],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '₹ Amount',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final List<QuickExpense> updated = [];
                        final defaults = getDefaultQuickExpenses();
                        for (int i = 0; i < quickExpensesCount; i++) {
                          final name = nameControllers[i].text.trim();
                          final emoji = emojiControllers[i].text.trim();
                          final amount = double.tryParse(
                            amountControllers[i].text.trim(),
                          );
                          final fallback = i < quickExpenses.length
                              ? quickExpenses[i]
                              : defaults[i];

                          updated.add(
                            QuickExpense(
                              name: name.isNotEmpty ? name : fallback.name,
                              amount: (amount != null && amount > 0)
                                  ? amount
                                  : fallback.amount,
                              emoji: emoji.isNotEmpty ? emoji : fallback.emoji,
                              categoryId: fallback.categoryId,
                            ),
                          );
                        }
                        await saveQuickExpenses(updated);
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
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

  Color getDailyCapColor(DailyCapTrend trend) {
    switch (trend) {
      case DailyCapTrend.increased:
        return AppColors.success;
      case DailyCapTrend.decreased:
        return AppColors.danger;
      case DailyCapTrend.unchanged:
        return AppColors.ink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final isOnTrack =
        dashboard.baseDailyCap == 0 ||
        dashboard.spentToday <= dashboard.baseDailyCap;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Month text + Profile icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM').format(DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: IconButton(
                      onPressed: openProfile,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.person_outline),
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 2. Month Summary (Remaining & Spent side by side)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THIS MONTH',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: HomepageTile(
                          label: 'Remaining',
                          amount: dashboard.remainingPool,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: HomepageTile(
                          label: 'Spent',
                          amount: dashboard.spentThisMonth,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 3. Main Spending Card (Safe to Spend + Daily Cap + Spent Today progress)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: HomepageTile(
                            label: 'Today\'s Limit',
                            amount: dashboard.safeToSpend,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: HomepageTile(
                            label: 'Daily Budget',
                            amount: dashboard.dailyCap,
                            color: getDailyCapColor(dashboard.dailyCapTrend),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent today',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          '₹${dashboard.spentToday.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isOnTrack ? AppColors.ink : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: dashboard.progress.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOnTrack ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 4. Log Expense Action Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: openLogExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 21),
                  label: Text(
                    'Log Expense',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 5. Quick Log Expenses Section
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QUICK LOG EXPENSES',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: AppColors.ink,
                        ),
                      ),
                      GestureDetector(
                        onTap: openEditQuickExpensesDialog,
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 94,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < quickExpensesCount; i++) ...[
                            SizedBox(
                              width: 72,
                              child: QuickExpenseButton(
                                expense: i < quickExpenses.length
                                    ? quickExpenses[i]
                                    : null,
                                onTap: () => handleQuickExpenseTap(i),
                              ),
                            ),
                            if (i != quickExpensesCount - 1)
                              const SizedBox(width: AppSpacing.sm),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                NavBarItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  selected: true,
                  onTap: () {},
                ),
                NavBarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Expenses',
                  selected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpenseHistory(),
                      ),
                    );
                  },
                ),
                NavBarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Budget',
                  selected: false,
                  onTap: () {},
                ),
                NavBarItem(
                  icon: Icons.bar_chart_outlined,
                  label: 'Analytics',
                  selected: false,
                  onTap: () {},
                ),
                NavBarItem(
                  icon: Icons.event_note_outlined,
                  label: 'Schedule',
                  selected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
