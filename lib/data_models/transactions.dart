import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { expense, income }

enum PaymentMethod { cash, upi, card, other }

enum TransactionSource { manual, quick, scheduled }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String categoryId;
  final String? note;
  final DateTime occurredAt;
  final String cycleId;
  final PaymentMethod paymentMethod;
  final TransactionSource source;
  final String? recurringItemId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    this.note,
    required this.occurredAt,
    required this.cycleId,
    required this.paymentMethod,
    required this.source,
    this.recurringItemId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      type: TransactionType.values.byName(map['type']),
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['categoryId'] as String,
      note: map['note'] as String?,
      occurredAt: (map['occurredAt'] as Timestamp).toDate(),
      cycleId: map['cycleId'] as String,
      paymentMethod: PaymentMethod.values.byName(map['paymentMethod']),
      source: TransactionSource.values.byName(map['source']),
      recurringItemId: map['recurringItemId'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'amount': amount,
      'categoryId': categoryId,
      'note': note,
      'occurredAt': Timestamp.fromDate(occurredAt),
      'cycleId': cycleId,
      'paymentMethod': paymentMethod.name,
      'source': source.name,
      'recurringItemId': recurringItemId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
