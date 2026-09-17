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
    'Personal',
    'Bills',
    'Travel',
    'Gifts',
    'Other',
  ];

  static const List<String> quickCategories = [
    'Food',
    'Transport',
    'Hostel',
    'Laundry',
    'Shopping',
    'Entertainment',
  ];

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
      case 'Travel':
        return Icons.flight_outlined;
      case 'Gifts':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.more_horiz;
    }
  }
}
