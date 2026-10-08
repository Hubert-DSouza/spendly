import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsModel {
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime date;
  final String? id;
  SavingsModel({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.date,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "targetAmount": targetAmount,
      "savedAmount": savedAmount,
      "date": Timestamp.fromDate(date),
    };
  }
}

SavingsModel fromMap(String id, Map<String, dynamic> map) {
  return SavingsModel(
    targetAmount: (map['targetAmount'] as num).toDouble(),
    savedAmount: (map['savedAmount'] as num).toDouble(),
    title: map['title'],
    date: (map['date'] as Timestamp).toDate(),
    id: id,
  );
}
