import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';

class TransactionNotifier extends Notifier<List<TransactionModel>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  List<TransactionModel> build() => const [];

  CollectionReference<Map<String, dynamic>> get _transactionsRef {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  Future<void> loadTransactions() async {
    final snapshot = await _transactionsRef
        .orderBy('occurredAt', descending: true)
        .get();

    final list = snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
        .toList();

    state = list;
  }

  Future<void> logExpense({
    required double amount,
    required String categoryId,
    String? note,
    TransactionSource source = TransactionSource.manual,
  }) async {
    final now = DateTime.now();
    final transaction = TransactionModel(
      id: now.millisecondsSinceEpoch.toString(),
      amount: amount,
      categoryId: categoryId,
      note: note,
      occurredAt: now,
      source: source,
      recurringItemId: null,
      createdAt: now,
      updatedAt: now,
    );

    await _transactionsRef.doc(transaction.id).set(transaction.toMap());
    state = [transaction, ...state];
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionsRef.doc(transaction.id).set(transaction.toMap());
    state = [transaction, ...state];
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionsRef.doc(transaction.id).update(transaction.toMap());
    state = [
      for (final item in state)
        if (item.id == transaction.id) transaction else item,
    ];
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsRef.doc(id).delete();
    state = state.where((item) => item.id != id).toList();
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<TransactionModel>>(
      TransactionNotifier.new,
    );
