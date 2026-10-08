import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> categories = [
    'Food',
    'Transport',
    'Hostel',
    'Laundry',
    'Shopping',
    'Entertainment',
    'Education',
    'Subscriptions',
    'Health',
    'Bills',
    'Other',
  ];


  static const Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Hostel': Colors.green,
    'Laundry': Colors.purple,
    'Shopping': Colors.pink,
    'Entertainment': Colors.red,
    'Education': Colors.yellow,
    'Subscriptions': Colors.indigo,
    'Health': Colors.teal,
    'Bills': Colors.cyan,
    'Other': Colors.grey,
  };

  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'Food':
        return Icons.restaurant_outlined;
      case 'Transport':
        return Icons.directions_car_outlined;
      case 'Hostel':
        return Icons.home_outlined;
      case 'Laundry':
        return Icons.local_laundry_service_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Education':
        return Icons.school_outlined;
      case 'Subscriptions':
        return Icons.subscriptions_outlined;
      case 'Health':
        return Icons.favorite_outline;
      case 'Personal':
        return Icons.person_outline;
      case 'Bills':
        return Icons.receipt_long_outlined;
      default:
        return Icons.more_horiz;
    }
  }
}
