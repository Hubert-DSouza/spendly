import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsNotifier extends Notifier<double?> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  double? build() => null;

  DocumentReference<Map<String, dynamic>> get settingsDoc {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('config');
  }

  Future<void> loadPoolAmount() async {
    final snapshot = await settingsDoc.get();

    final data = snapshot.data();

    final pool = data?['poolAmount'];

    state = (pool as num?)?.toDouble();
  }

  Future<void> savePoolAmount(double amount) async {
    await settingsDoc.set({'poolAmount': amount}, SetOptions(merge: true));

    state = amount;
  }

  Future<void> addPoolAmount(double amount) async {
    final pool = state ?? 0;

    state = pool + amount;

    await savePoolAmount(state!);
  }
}

final userSettingsProvider = NotifierProvider<UserSettingsNotifier, double?>(
  UserSettingsNotifier.new,
);
