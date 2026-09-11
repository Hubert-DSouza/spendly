import 'package:cloud_firestore/cloud_firestore.dart';

enum CycleStatus { active, completed, archived }

class Cycle {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double startingAmount;
  final double carryInAmount;
  final double reserveAmount;
  final CycleStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startingAmount,
    required this.carryInAmount,
    required this.reserveAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cycle.fromMap(String id, Map<String, dynamic> map) {
    return Cycle(
      id: id,
      name: map['name'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      startingAmount: (map['startingAmount'] as num).toDouble(),
      carryInAmount: (map['carryInAmount'] as num).toDouble(),
      reserveAmount: (map['reserveAmount'] as num).toDouble(),
      status: CycleStatus.values.byName(map['status']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'startingAmount': startingAmount,
      'carryInAmount': carryInAmount,
      'reserveAmount': reserveAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
