import 'package:cloud_firestore/cloud_firestore.dart';

class QuickExpense {
  final String id;
  final String name;
  final double amount;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuickExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuickExpense.fromMap(String id, Map<String, dynamic> map) {
    return QuickExpense(
      id: id,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      active: map['active'] as bool? ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
