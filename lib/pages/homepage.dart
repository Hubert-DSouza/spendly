import 'package:expense_tracker/constants/app_constants.dart';
import 'package:expense_tracker/pages/user_settings_page.dart';
import 'package:expense_tracker/providers/savings_provider.dart';
import 'package:expense_tracker/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/transaction_provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<HomePage> createState() => HomePageState();
// }

// class HomePageState extends ConsumerState<HomePage> {
//   final amountController = TextEditingController();
//   final noteController = TextEditingController();
//   String selectedCategory = 'Food';

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   @override
//   void dispose() {
//     amountController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }

//   Future<void> loadData() async {
//     await ref.read(userSettingsProvider.notifier).loadPoolAmount();
//     await ref.read(transactionProvider.notifier).loadTransactions();
//   }

//   void openProfile() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UserSettingsPage()),
//     );
//   }

//   Future<void> addExpense() async {
//     final parsedAmount = double.tryParse(amountController.text.trim());
//     if (parsedAmount == null || parsedAmount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid amount')),
//       );
//       return;
//     }

//     final noteText = noteController.text.trim();

//     try {
//       await ref
//           .read(transactionProvider.notifier)
//           .logExpense(
//             amount: parsedAmount,
//             categoryId: selectedCategory,
//             note: noteText.isEmpty ? null : noteText,
//             source: TransactionSource.manual,
//           );
//       if (!mounted) return;

//       amountController.clear();
//       noteController.clear();
//       FocusScope.of(context).unfocus();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             '₹${parsedAmount.toStringAsFixed(0)} logged in $selectedCategory',
//             style: GoogleFonts.poppins(fontSize: 13),
//           ),
//           duration: const Duration(seconds: 1),
//         ),
//       );
//     } catch (_) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not save expense.')),
//         );
//       }
//     }
//   }

//   void applyTransactionTemplate(TransactionModel transaction) {
//     setState(() {
//       amountController.text = transaction.amount.toStringAsFixed(0);
//       noteController.text = transaction.note ?? '';
//       if (AppConstants.categories.contains(transaction.categoryId)) {
//         selectedCategory = transaction.categoryId;
//       }
//     });
//   }

//   Color getDailyCapColor(DailyCapTrend trend) {
//     switch (trend) {
//       case DailyCapTrend.increased:
//         return AppColors.success;
//       case DailyCapTrend.decreased:
//         return AppColors.danger;
//       case DailyCapTrend.unchanged:
//         return AppColors.ink;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dashboard = ref.watch(dashboardProvider);
//     final isOnTrack =
//         dashboard.baseDailyCap == 0 ||
//         dashboard.spentToday <= dashboard.baseDailyCap;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(
//             AppSpacing.xl,
//             AppSpacing.lg,
//             AppSpacing.xl,
//             AppSpacing.xxxl,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Header (Month text + Profile icon)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     DateFormat('MMMM').format(DateTime.now()),
//                     style: GoogleFonts.poppins(
//                       fontSize: 28,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.ink,
//                     ),
//                   ),
//                   Container(
//                     width: 42,
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: AppColors.surface,
//                       borderRadius: BorderRadius.circular(AppRadius.md),
//                       border: Border.all(color: AppColors.border),
//                     ),
//                     child: IconButton(
//                       onPressed: openProfile,
//                       padding: EdgeInsets.zero,
//                       icon: const Icon(Icons.person_outline),
//                       color: AppColors.ink,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: AppSpacing.xxl),

//               // 2. Month Summary (Remaining & Spent side by side)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text(
//                   //   'THIS MONTH',
//                   //   style: GoogleFonts.poppins(
//                   //     fontSize: 12,
//                   //     fontWeight: FontWeight.w600,
//                   //     letterSpacing: 0.4,
//                   //     color: AppColors.ink,
//                   //   ),
//                   // ),
//                   // const SizedBox(height: AppSpacing.sm),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: HomepageTile(
//                           label: 'Remaining',
//                           amount: dashboard.remainingPool,
//                           color: AppColors.ink,
//                         ),
//                       ),
//                       const SizedBox(width: AppSpacing.md),
//                       Expanded(
//                         child: HomepageTile(
//                           label: 'Spent',
//                           amount: dashboard.spentThisMonth,
//                           color: AppColors.ink,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: AppSpacing.xl),

//               // 3. Main Spending Card (Today's Limit + Daily Budget + Spent Today progress)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(AppRadius.lg),
//                   border: Border.all(color: AppColors.border),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: HomepageTile(
//                             label: 'Today\'s Limit',
//                             amount: dashboard.safeToSpend,
//                             color: AppColors.ink,
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.md),
//                         Expanded(
//                           child: HomepageTile(
//                             label: 'Daily Budget',
//                             amount: dashboard.dailyCap,
//                             color: getDailyCapColor(dashboard.dailyCapTrend),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Spent today',
//                           style: GoogleFonts.poppins(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.muted,
//                           ),
//                         ),
//                         Text(
//                           '₹${dashboard.spentToday.toStringAsFixed(0)}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             color: isOnTrack ? AppColors.ink : AppColors.danger,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.xs),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: LinearProgressIndicator(
//                         value: dashboard.progress.clamp(0.0, 1.0),
//                         minHeight: 8,
//                         backgroundColor: AppColors.border,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           isOnTrack ? AppColors.success : AppColors.danger,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: AppSpacing.xl),

//               // 4. Log Expense & Recent Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(AppRadius.lg),
//                   border: Border.all(color: AppColors.border),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'LOG EXPENSE',
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.4,
//                         color: AppColors.ink,
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.md),

//                     // Recent Templates
//                     // Text(
//                     //   'Recent',
//                     //   style: GoogleFonts.poppins(
//                     //     fontSize: 12,
//                     //     fontWeight: FontWeight.w500,
//                     //     color: AppColors.muted,
//                     //   ),
//                     // ),
//                     // const SizedBox(height: AppSpacing.sm),
//                     // if (recentTransactions.isEmpty)
//                     //   Text(
//                     //     'No recent expenses',
//                     //     style: GoogleFonts.poppins(
//                     //       fontSize: 12,
//                     //       color: AppColors.muted,
//                     //     ),
//                     //   )
//                     // else
//                     //   SingleChildScrollView(
//                     //     scrollDirection: Axis.horizontal,
//                     //     child: Row(
//                     //       children: [
//                     //         for (final tx in recentTransactions) ...[
//                     //           OutlinedButton(
//                     //             onPressed: () => applyTransactionTemplate(tx),
//                     //             style: OutlinedButton.styleFrom(
//                     //               backgroundColor: AppColors.surface,
//                     //               side: const BorderSide(
//                     //                 color: AppColors.border,
//                     //               ),
//                     //               shape: RoundedRectangleBorder(
//                     //                 borderRadius: BorderRadius.circular(
//                     //                   AppRadius.md,
//                     //                 ),
//                     //               ),
//                     //               padding: const EdgeInsets.symmetric(
//                     //                 horizontal: 14,
//                     //                 vertical: 10,
//                     //               ),
//                     //             ),
//                     //             child: Text(
//                     //               '${tx.note ?? tx.categoryId}  ₹${tx.amount.toStringAsFixed(0)}',
//                     //               style: GoogleFonts.poppins(
//                     //                 fontSize: 12,
//                     //                 fontWeight: FontWeight.w500,
//                     //                 color: AppColors.ink,
//                     //               ),
//                     //             ),
//                     //           ),
//                     //           const SizedBox(width: AppSpacing.sm),
//                     //         ],
//                     //       ],
//                     //     ),
//                     //   ),
//                     // const SizedBox(height: AppSpacing.lg),

//                     // Amount Field
//                     // Amount & Category Fields Side-by-Side
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Amount Field
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Amount',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.muted,
//                                 ),
//                               ),
//                               const SizedBox(height: AppSpacing.sm),
//                               TextField(
//                                 controller: amountController,
//                                 keyboardType:
//                                     const TextInputType.numberWithOptions(
//                                       decimal: true,
//                                     ),
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.ink,
//                                 ),
//                                 decoration: InputDecoration(
//                                   prefixText: '₹ ',
//                                   prefixStyle: GoogleFonts.poppins(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.ink,
//                                   ),
//                                   hintText: '0.00',
//                                   hintStyle: GoogleFonts.poppins(
//                                     fontSize: 18,
//                                     color: AppColors.border,
//                                   ),
//                                   filled: true,
//                                   fillColor: AppColors.surface,
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: AppSpacing.md,
//                                     vertical: 13.5,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.border,
//                                     ),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.border,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.primary,
//                                       width: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.md),

//                         // Category Field
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Category',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.muted,
//                                 ),
//                               ),
//                               const SizedBox(height: AppSpacing.sm),
//                               DropdownButtonFormField<String>(
//                                 key: ValueKey(selectedCategory),
//                                 initialValue: selectedCategory,
//                                 items: AppConstants.categories.map((category) {
//                                   return DropdownMenuItem<String>(
//                                     value: category,
//                                     child: Text(
//                                       category,
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: AppColors.ink,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     setState(() => selectedCategory = value);
//                                   }
//                                 },
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.ink,
//                                 ),
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: AppColors.surface,
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: AppSpacing.md,
//                                     vertical: 13.5,
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.border,
//                                     ),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.border,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       AppRadius.md,
//                                     ),
//                                     borderSide: const BorderSide(
//                                       color: AppColors.primary,
//                                       width: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                                 icon: const Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: AppColors.muted,
//                                 ),
//                                 dropdownColor: AppColors.surface,
//                                 borderRadius: BorderRadius.circular(
//                                   AppRadius.md,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),

//                     // Note Field
//                     Text(
//                       'Note (optional)',
//                       style: GoogleFonts.poppins(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.muted,
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.sm),
//                     AppTextField(
//                       controller: noteController,
//                       hint: 'e.g. Dinner with friends',
//                       icon: Icons.edit_note_outlined,
//                     ),
//                     const SizedBox(height: AppSpacing.xxl),

//                     // Log Expense Submit Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 54,
//                       child: ElevatedButton.icon(
//                         onPressed: addExpense,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.md),
//                           ),
//                         ),
//                         icon: const Icon(Icons.add, size: 21),
//                         label: Text(
//                           'Log Expense',
//                           style: GoogleFonts.poppins(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
//     );
//   }
// }

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? selectedCategory = "Food";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(transactionProvider.notifier).loadTransactions();
    ref.read(userSettingsProvider.notifier).loadPoolAmount();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final userSettings = ref.watch(userSettingsProvider);
    final dashboard = ref.watch(dashboardProvider);
    double totalSavings = 0;
    final savings = [...ref.watch(savingsProvider)];
    DateTime? selectedDate;

    for (var goal in savings) {
      totalSavings += ref.read(savingsProvider.notifier).toSavePerDay(goal);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        minimum: EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main month display
              Row(
                children: [
                  Text(
                    DateFormat('MMMM').format(DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Spacer(),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) {
                  //           return UserSettingsPage();
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   icon: Icon(Icons.person_2_outlined),
                  //   style: ButtonStyle(
                  //     backgroundColor: WidgetStatePropertyAll(AppColors.border),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Container(
                color: AppColors.surface,
                child: Column(
                  children: [
                    Text(
                      "Daily Budget",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    //remaining and spent display
                    Row(
                      children: [
                        Expanded(
                          child: Card(
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
                            elevation: 0,
                            child: Column(
                              children: [
                                Text(
                                  "Projected Limit",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                                Text(
                                  '₹${ref.read(dashboardProvider.notifier).forecastedDailyBudget().toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    color: ref
                                        .read(dashboardProvider.notifier)
                                        .budgetStatusColor(),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Calculated for remaining days.",
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
                        Text(
                          "Today's Spending: ",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '₹${ref.read(dashboardProvider.notifier).spentToday().toStringAsFixed(2)}/${ref.read(dashboardProvider.notifier).dailyBudget().toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value:
                          ref.read(dashboardProvider.notifier).spentToday() /
                          ref.read(dashboardProvider.notifier).dailyBudget(),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(50),
                    ),

                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
              //SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Monthly Recap",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${DateFormat('d').format(DateTime.now())} / ${DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day.toString()} days',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 0,
                            child: Row(
                              children: [
                                Icon(Icons.currency_rupee_outlined, size: 30),
                                SizedBox(width: 25),
                                Column(
                                  children: [
                                    Text(
                                      "Spent",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                    Text(
                                      '₹${ref.read(dashboardProvider.notifier).spentThisMonth().toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 0,
                            child: Row(
                              children: [
                                Icon(Icons.wallet_outlined, size: 30),
                                SizedBox(width: 25),
                                Column(
                                  children: [
                                    Text(
                                      "Remaining",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                    Text(
                                      '₹${(ref.read(dashboardProvider.notifier).monthlyPool() - ref.read(dashboardProvider.notifier).spentThisMonth()).toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Column(
                  children: [
                    Text(
                      "Log an Expense",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),

                    //log expense display
                    Column(
                      children: [
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Amount",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        10,
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: TextField(
                                        controller: amountController,
                                        decoration: InputDecoration(
                                          hintText: "0.00",
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 14,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: AppColors.border,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Category",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  DropdownMenu<String>(
                                    width: 150,
                                    menuHeight: 300,
                                    dropdownMenuEntries: AppConstants.categories
                                        .map((category) {
                                          return DropdownMenuEntry(
                                            value: category,
                                            label: category,
                                          );
                                        })
                                        .toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                    },
                                    inputDecorationTheme: InputDecorationTheme(
                                      filled: true,
                                      fillColor: AppColors.surface,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.md,
                                            vertical: 13.5,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          "Note (optional)",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppRadius.md,
                          ),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextField(
                              controller: noteController,
                              decoration: InputDecoration(
                                hintText: "e.g Dinner with friends",
                                prefixIcon: Icon(
                                  Icons.edit_note_outlined,
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
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(transactionProvider.notifier)
                                  .addTransaction(
                                    double.parse(amountController.text),
                                    selectedCategory!,
                                    noteController.text,
                                    DateTime.now(),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Success"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.primary,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.md,
                                  ),
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all(
                                Size(double.infinity, 50),
                              ),
                            ),
                            label: Text(
                              "Log Expense",
                              style: GoogleFonts.poppins(
                                color: AppColors.background,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            icon: Icon(Icons.add, color: AppColors.background),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
