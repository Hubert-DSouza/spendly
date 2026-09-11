import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker/theme/app_colors.dart';
import 'package:expense_tracker/theme/app_radius.dart';
import 'package:expense_tracker/theme/app_spacing.dart';

import 'log_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --------------------------------------------------
  // QUICK EXPENSES
  // --------------------------------------------------

  final List<Map<String, dynamic>?> quickExpenses = [
    {'name': 'Chai', 'amount': 20.0},
    {'name': 'Canteen', 'amount': 80.0},
    {'name': 'Laundry', 'amount': 50.0},
    {'name': 'Auto', 'amount': 40.0},
    null,
  ];

  bool _editingQuickExpenses = false;

  // --------------------------------------------------
  // OPEN LOG EXPENSE
  // --------------------------------------------------

  void _openLogExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return const LogExpensePage();
      },
    );
  }

  // --------------------------------------------------
  // QUICK EXPENSE TAP
  // --------------------------------------------------

  void _handleQuickExpenseTap(int index) {
    if (_editingQuickExpenses) {
      _editQuickExpense(index);
      return;
    }

    final expense = quickExpenses[index];

    if (expense == null) {
      _editQuickExpense(index);
      return;
    }

    final String name = expense['name'];
    final double amount = expense['amount'];

    // Firebase will be connected later.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name • ₹${amount.toStringAsFixed(0)} logged',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --------------------------------------------------
  // EDIT QUICK EXPENSE
  // --------------------------------------------------

  void _editQuickExpense(int index) {
    final expense = quickExpenses[index];

    final nameController = TextEditingController(text: expense?['name'] ?? '');

    final amountController = TextEditingController(
      text: expense?['amount']?.toStringAsFixed(0) ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              top: AppSpacing.lg,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Title
                Text(
                  expense == null ? 'Add quick expense' : 'Edit quick expense',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Name
                Text(
                  'Name',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Chai',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Amount
                Text(
                  'Amount',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    hintText: '20',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Save
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();

                      final amount = double.tryParse(amountController.text);

                      if (name.isEmpty || amount == null || amount <= 0) {
                        return;
                      }

                      setState(() {
                        quickExpenses[index] = {
                          'name': name,
                          'amount': amount,                          
                        };
                      });

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Remove existing shortcut
                if (expense != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          quickExpenses[index] = null;
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Remove shortcut',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }


  
  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Temporary values.
    // These will later come from the budget engine.

    const double dailyCap = 500;
    const double spentToday = 320;
    const double safeToSpend = 180;
    const double dailyCapChange = 35;

    final bool underDailyCap = spentToday <= dailyCap;

    final double progress = (spentToday / dailyCap).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // HEADER
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good evening',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // --------------------------------------------------
              // SAFE TO SPEND
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAFE TO SPEND TODAY',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.muted,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      '₹${safeToSpend.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      'you can spend this much more today',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.muted,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily cap',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          '₹${dailyCap.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent today',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          '₹${spentToday.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: underDailyCap
                                ? AppColors.ink
                                : AppColors.danger,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          underDailyCap ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).round()}% of daily cap',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          underDailyCap ? 'On track' : 'Over daily cap',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: underDailyCap
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 17,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '₹${dailyCapChange.toStringAsFixed(0)} more available than yesterday',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // --------------------------------------------------
              // QUICK LOG EXPENSES
              // --------------------------------------------------
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
                    onTap: () {
                      setState(() {
                        _editingQuickExpenses = !_editingQuickExpenses;
                      });
                    },
                    child: Text(
                      _editingQuickExpenses ? 'Done' : 'Edit',
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

              // Exactly five fixed slots.
              Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == 4 ? 0 : AppSpacing.sm,
                      ),
                      child: _QuickExpenseButton(
                        expense: quickExpenses[index],
                        editing: _editingQuickExpenses,
                        onTap: () => _handleQuickExpenseTap(index),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // --------------------------------------------------
              // LOG EXPENSE
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _openLogExpense(context),
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Log expense',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // --------------------------------------------------
              // RECENT EXPENSES
              // --------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent expenses',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              const _ExpenseTile(
                title: 'Lunch',
                category: 'Food',
                amount: 120,
                icon: Icons.restaurant_outlined,
              ),

              const _ExpenseTile(
                title: 'Auto',
                category: 'Transport',
                amount: 80,
                icon: Icons.directions_car_outlined,
              ),

              const _ExpenseTile(
                title: 'Laundry',
                category: 'Hostel',
                amount: 60,
                icon: Icons.local_laundry_service_outlined,
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),

      // --------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}

// ================================================================
// QUICK EXPENSE BUTTON
// ================================================================

class _QuickExpenseButton extends StatelessWidget {
  final Map<String, dynamic>? expense;
  final bool editing;
  final VoidCallback onTap;

  const _QuickExpenseButton({
    required this.expense,
    required this.editing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = expense == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  const SizedBox(height: AppSpacing.xs),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      isEmpty ? 'Add expense' : expense?['name'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isEmpty ? AppColors.muted : AppColors.ink,
                      ),
                    ),
                  ),

                  if (!isEmpty)
                    Text(
                      '₹${(expense?['amount'] as double).toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                ],
              ),
            ),

            // Small edit icon while editing.
            if (editing)
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  isEmpty ? Icons.add : Icons.edit_outlined,
                  size: 13,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// EXPENSE TILE
// ================================================================

class _ExpenseTile extends StatelessWidget {
  final String title;
  final String category;
  final double amount;
  final IconData icon;

  const _ExpenseTile({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Icon(icon, size: 20, color: AppColors.muted),
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
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '-₹${amount.toStringAsFixed(0)}',
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
