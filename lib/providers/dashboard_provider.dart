// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/transaction.dart';
// import 'transaction_provider.dart';
// import 'user_settings_provider.dart';

// enum DailyCapTrend { unchanged, increased, decreased }

// class DashboardData {
//   final double monthlyPool;
//   final double spentThisMonth;
//   final double spentToday;
//   final double remainingPool;
//   final int daysRemaining;
//   final double baseDailyCap;
//   final double dailyCap;
//   final double safeToSpend;
//   final double progress;
//   final DailyCapTrend dailyCapTrend;

//   DashboardData({
//     required this.monthlyPool,
//     required this.spentThisMonth,
//     required this.spentToday,
//     required this.remainingPool,
//     required this.daysRemaining,
//     required this.baseDailyCap,
//     required this.dailyCap,
//     required this.safeToSpend,
//     required this.progress,
//     required this.dailyCapTrend,
//   });
// }

// class DashboardNotifier extends Notifier<DashboardData> {
//   @override
//   DashboardData build() {
//     final pool = ref.watch(userSettingsProvider);
//     final transactions = ref.watch(transactionProvider);

//     return calculateDashboard(pool, transactions);
//   }

//   DashboardData calculateDashboard(
//     double? pool,
//     List<TransactionModel> transactions,
//   ) {
//     final monthlyPool = pool ?? 0;
//     final now = DateTime.now();

//     // 1. Calculate spent amounts in a single pass
//     double spentThisMonth = 0;
//     double spentToday = 0;

//     for (final t in transactions) {
//       if (t.occurredAt.year == now.year &&
//           t.occurredAt.month == now.month) {
//         spentThisMonth += t.amount;
//         if (t.occurredAt.day == now.day) {
//           spentToday += t.amount;
//         }
//       }
//     }

//     // 2. Calculate pools and days
//     final spentBeforeToday = spentThisMonth - spentToday;
//     final remainingPool = (monthlyPool - spentThisMonth).clamp(0.0, double.infinity);
//     final poolBeforeToday = (monthlyPool - spentBeforeToday).clamp(0.0, double.infinity);

//     final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
//     final daysRemaining = lastDayOfMonth.day - now.day + 1;

//     // 3. Calculate base daily cap for today
//     final baseDailyCap = daysRemaining > 0 ? poolBeforeToday / daysRemaining : 0.0;

//     // 4. Calculate safe to spend today
//     final safeToSpend = (baseDailyCap - spentToday).clamp(0.0, double.infinity);

//     // 5. Calculate updated daily cap for remaining days & trend
//     double dailyCap = baseDailyCap;
//     DailyCapTrend trend = DailyCapTrend.unchanged;

//     if (spentToday > 0) {
//       final futureDays = daysRemaining > 1 ? daysRemaining - 1 : 1;
//       dailyCap = remainingPool / futureDays;

//       if (spentToday < baseDailyCap) {
//         trend = DailyCapTrend.increased;
//       } else if (spentToday > baseDailyCap) {
//         trend = DailyCapTrend.decreased;
//       }
//     }

//     // 6. Calculate progress bar ratio
//     final progress = baseDailyCap > 0 ? (spentToday / baseDailyCap).clamp(0.0, 1.0) : 0.0;

//     return DashboardData(
//       monthlyPool: monthlyPool,
//       spentThisMonth: spentThisMonth,
//       spentToday: spentToday,
//       remainingPool: remainingPool,
//       daysRemaining: daysRemaining,
//       baseDailyCap: baseDailyCap,
//       dailyCap: dailyCap,
//       safeToSpend: safeToSpend,
//       progress: progress,
//       dailyCapTrend: trend,
//     );
//   }
// }

// final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardData>(
//   DashboardNotifier.new,
// );

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'transaction_provider.dart';
import 'user_settings_provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DashboardNotifier extends Notifier<void> {
  @override
  void build() {
    //DashboardNotifier depends on both the user settings and transactionsproviders
    //whenever they update, the dashboard should be rebuilt
    ref.watch(transactionProvider);
    ref.watch(userSettingsProvider);
  }

  double monthlyPool() {
    //user settings provider is of state double
    return ref.read(userSettingsProvider) ?? 0;
  }

  double spentThisMonth() {
    final transactions = ref.read(transactionProvider);
    final now = DateTime.now();

    double total = 0;

    //transactionsprovider is of state List<Transaction> which means it contains all transactions
    //so we need to filter out the transactions that belong to the current month
    for (final transaction in transactions) {
      if (transaction.occurredAt.year == now.year &&
          transaction.occurredAt.month == now.month) {
        total += transaction.amount;
      }
    }

    return total;
  }

  double spentToday() {
    final transactions = ref.read(transactionProvider);
    final now = DateTime.now();

    double total = 0;

    for (final transaction in transactions) {
      if (transaction.occurredAt.year == now.year &&
          transaction.occurredAt.month == now.month &&
          transaction.occurredAt.day == now.day) {
        total += transaction.amount;
      }
    }

    return total;
  }

  int daysRemaining() {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return lastDayOfMonth.day - now.day + 1;
  }

  double dailyBudget() {
    final pool = monthlyPool();
    final spent = spentThisMonth();
    final days = daysRemaining();
    final todaySpent = spentToday();

    final remainingAtStartOfToday = pool - spent + todaySpent;

    if (days > 0) {
      return remainingAtStartOfToday / days;
    } else {
      return 0;
    }
  }

  double forecastedDailyBudget() {
  final remaining = (monthlyPool() - spentThisMonth())
      .clamp(0.0, double.infinity);

  final days = daysRemaining();

  final futureDays = days > 1 ? days - 1 : 1;

  return remaining / futureDays;
}

  Color budgetStatusColor() {
    if (dailyBudget() - spentToday() >= 0) {
      return AppColors.success;
    } else {
      return AppColors.danger;
    }
  }

  double todaysLimit() {
    return (dailyBudget() - spentToday()).clamp(0.0, double.infinity);
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, void>(
  DashboardNotifier.new,
);
