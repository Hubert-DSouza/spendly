import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsNotifier extends Notifier<double?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  double? build() => null;

  DocumentReference<Map<String, dynamic>> get _userDoc {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid);
  }

  Future<void> loadPoolAmount() async {
    final snapshot = await _userDoc.get();
    final data = snapshot.data();
    final pool = data?['settings']?['poolAmount'];
    state = (pool as num?)?.toDouble();
  }

  Future<void> savePoolAmount(double amount) async {
    await _userDoc.set({
      'settings': {'poolAmount': amount},
    }, SetOptions(merge: true));
    state = amount;
  }
}

final userSettingsProvider = NotifierProvider<UserSettingsNotifier, double?>(
  UserSettingsNotifier.new,
);
