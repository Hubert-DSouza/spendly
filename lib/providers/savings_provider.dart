import 'package:expense_tracker/models/savings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingsProvider extends Notifier<List<SavingsModel>> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get savingsRef {
    final user = auth.currentUser!;
    return firestore.collection('users').doc(user.uid).collection('savings');
  }

  @override
  List<SavingsModel> build() {
    // TODO: implement build
    return const [];
  }

  Future<void> loadSavings() async {
    final rawSavings = await savingsRef.get();
    final savings = rawSavings.docs.map((doc) {
      return fromMap(doc.id, doc.data());
    }).toList();
    state = savings;
  }

  Future<void> addSavings(
    String title,
    double savedAmount,
    double targetAmount,
    DateTime date,
  ) async {
    final doc = savingsRef.doc();
    final savings = SavingsModel(
      savedAmount: savedAmount,
      targetAmount: targetAmount,
      title: title,
      date: date,
      id: doc.id,
    );
    await doc.set(savings.toMap());
    state = [savings, ...state];
  }

  Future<void> removeSavings(String id) async {
    await savingsRef.doc(id).delete();
    state = state.where((s) => s.id != id).toList();
  }

  Future<void> updateSavings(SavingsModel saving) async {
    await savingsRef.doc(saving.id).update(saving.toMap());
    state = state.map((s) => s.id == saving.id ? saving : s).toList();
  }

  double toSavePerDay(SavingsModel savings) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final target = DateTime(
      savings.date.year,
      savings.date.month,
      savings.date.day,
    );

    final daysRemaining = target.difference(today).inDays;

    return (savings.targetAmount - savings.savedAmount) / daysRemaining;
  }

  double daysTillTarget(SavingsModel savings) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final target = DateTime(
      savings.date.year,
      savings.date.month,
      savings.date.day,
    );

    return target.difference(today).inDays.toDouble();
  }
}

final savingsProvider = NotifierProvider<SavingsProvider, List<SavingsModel>>(
  SavingsProvider.new,
);
