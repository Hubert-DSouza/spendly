import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expense_tracker/theme/app_colors.dart';
import 'package:expense_tracker/theme/app_radius.dart';
import 'package:expense_tracker/theme/app_spacing.dart';

class LogExpensePage extends StatefulWidget {
  const LogExpensePage({super.key});

  @override
  State<LogExpensePage> createState() => _LogExpensePageState();
}

class _LogExpensePageState extends State<LogExpensePage> {
  String amount = '';
  String selectedCategory = 'Food';

  final List<String> categories = [
    'Food',
    'Transport',
    'Hostel',
    'Laundry',
    'Shopping',
    'Entertainment',
    'Education',
    'Subscriptions',
    'Health',
    'Personal',
    'Bills',
    'Travel',
    'Gifts',
    'Other',
  ];

  // Categories shown immediately.
  final List<String> quickCategories = [
    'Food',
    'Transport',
    'Hostel',
    'Laundry',
    'Shopping',
    'Entertainment',
  ];

  void addNumber(String number) {
    setState(() {
      // Don't allow multiple decimal points.
      if (number == '.' && amount.contains('.')) {
        return;
      }

      // Don't allow more than two decimal places.
      if (amount.contains('.')) {
        final decimalPart = amount.split('.')[1];

        if (decimalPart.length >= 2) {
          return;
        }
      }

      // Prevent something like 000.
      if (amount == '0' && number != '.') {
        amount = number;
      } else {
        amount += number;
      }
    });
  }

  void deleteNumber() {
    if (amount.isEmpty) return;

    setState(() {
      amount = amount.substring(0, amount.length - 1);
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void showAllCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose category',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: categories.map((category) {
                    final selected = category == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        selectCategory(category);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  void addExpense() {
    final parsedAmount = double.tryParse(amount);

    if (parsedAmount == null || parsedAmount <= 0) {
      return;
    }

    // Firebase will be connected later.
    //
    // For now, return the expense data to HomePage.
    Navigator.pop(context, {
      'amount': parsedAmount,
      'category': selectedCategory,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasAmount = amount.isNotEmpty;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // HANDLE
              // --------------------------------------------------
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

              // --------------------------------------------------
              // TITLE
              // --------------------------------------------------
              Text(
                'Log expense',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // --------------------------------------------------
              // AMOUNT
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                  horizontal: AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      hasAmount ? amount : '0',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: hasAmount ? AppColors.ink : AppColors.border,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // --------------------------------------------------
              // CATEGORY
              // --------------------------------------------------
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ...quickCategories.map(
                    (category) => _CategoryButton(
                      label: category,
                      selected: category == selectedCategory,
                      onTap: () => selectCategory(category),
                    ),
                  ),

                  _CategoryButton(
                    label: 'More',
                    selected: false,
                    icon: Icons.more_horiz,
                    onTap: showAllCategories,
                  ),
                ],
              ),

              const Spacer(),

              // --------------------------------------------------
              // NUMBER PAD
              // --------------------------------------------------
              Column(
                children: [
                  Row(
                    children: [
                      _NumberButton(value: '1', onTap: () => addNumber('1')),
                      _NumberButton(value: '2', onTap: () => addNumber('2')),
                      _NumberButton(value: '3', onTap: () => addNumber('3')),
                    ],
                  ),

                  Row(
                    children: [
                      _NumberButton(value: '4', onTap: () => addNumber('4')),
                      _NumberButton(value: '5', onTap: () => addNumber('5')),
                      _NumberButton(value: '6', onTap: () => addNumber('6')),
                    ],
                  ),

                  Row(
                    children: [
                      _NumberButton(value: '7', onTap: () => addNumber('7')),
                      _NumberButton(value: '8', onTap: () => addNumber('8')),
                      _NumberButton(value: '9', onTap: () => addNumber('9')),
                    ],
                  ),

                  Row(
                    children: [
                      _NumberButton(value: '.', onTap: () => addNumber('.')),
                      _NumberButton(value: '0', onTap: () => addNumber('0')),
                      _NumberButton(
                        icon: Icons.backspace_outlined,
                        onTap: deleteNumber,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // --------------------------------------------------
              // ADD EXPENSE
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: hasAmount ? addExpense : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: AppColors.muted,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Add expense',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
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

// ================================================================
// CATEGORY BUTTON
// ================================================================

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _CategoryButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppColors.muted,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// NUMBER BUTTON
// ================================================================

class _NumberButton extends StatelessWidget {
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;

  const _NumberButton({this.value, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 21, color: AppColors.muted)
                  : Text(
                      value!,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
