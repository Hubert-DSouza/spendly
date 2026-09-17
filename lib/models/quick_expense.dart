import 'dart:convert';

class QuickExpense {
  final String name;
  final double amount;
  final String emoji;
  final String categoryId;

  const QuickExpense({
    required this.name,
    required this.amount,
    required this.emoji,
    this.categoryId = 'other',
  });

  factory QuickExpense.fromMap(Map<String, dynamic> map) {
    return QuickExpense(
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      emoji: map['emoji'] as String,
      categoryId: (map['categoryId'] as String?) ?? 'other',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'emoji': emoji,
      'categoryId': categoryId,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory QuickExpense.fromJson(String source) =>
      QuickExpense.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
