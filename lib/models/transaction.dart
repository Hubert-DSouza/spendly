import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionSource { manual, quick, scheduled }

class TransactionModel {
  final String id;
  final double amount;
  final String categoryId;
  final String? note;
  final DateTime occurredAt;
  final TransactionSource source;
  final String? recurringItemId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.note,
    required this.occurredAt,
    required this.source,
    this.recurringItemId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['categoryId'] as String,
      note: map['note'] as String?,
      occurredAt: (map['occurredAt'] as Timestamp).toDate(),
      source: TransactionSource.values.byName(map['source']),
      recurringItemId: map['recurringItemId'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'categoryId': categoryId,
      'note': note,
      'occurredAt': Timestamp.fromDate(occurredAt),
      'source': source.name,
      'recurringItemId': recurringItemId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
