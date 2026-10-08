import 'package:expense_tracker/constants/app_constants.dart';
import 'package:expense_tracker/pages/user_settings_page.dart';
import 'package:expense_tracker/providers/user_settings_provider.dart';
import 'package:expense_tracker/providers/savings_provider.dart';
import 'package:expense_tracker/widgets/savings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/transaction_provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';

class SavingsPage extends ConsumerStatefulWidget {
  const SavingsPage({super.key});

  @override
  ConsumerState<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends ConsumerState<SavingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    ref.read(savingsProvider.notifier).loadSavings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalSavings = 0;
    final savings = [...ref.watch(savingsProvider)];
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    DateTime? selectedDate;

    for (var goal in savings) {
      totalSavings += ref.read(savingsProvider.notifier).toSavePerDay(goal);
    }
    savings.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Savings Goals",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.surface),
                    textStyle: WidgetStatePropertyAll(
                      GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.surface,
                      ),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(24.0),
                          height: 400,
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Add Savings Goal",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSpacing.lg),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Title",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  TextField(
                                    controller: amountController,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "Target Amount",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          final pickedDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2030),
                                              );
                                          if (pickedDate != null) {
                                            setState(() {
                                              selectedDate = pickedDate;
                                            });
                                          }
                                        },
                                        child: Text("Choose Date"),
                                      ),
                                      Spacer(),
                                      Text(
                                        DateFormat("dd MMM yyyy").format(
                                          selectedDate ?? DateTime.now(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(savingsProvider.notifier)
                                          .addSavings(
                                            titleController.text,
                                            0,
                                            double.parse(amountController.text),
                                            selectedDate!,
                                          );
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Add"),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primary,
                                      ),
                                      foregroundColor: WidgetStatePropertyAll(
                                        AppColors.surface,
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Add Goal"),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              "Savings Target for Today: ₹${totalSavings.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            Expanded(
              child: ListView.builder(
                itemCount: savings.length,
                itemBuilder: (context, index) {
                  return SavingsTile(savingsGoal: savings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
