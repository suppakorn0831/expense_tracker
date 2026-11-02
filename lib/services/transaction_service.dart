import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String get uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get transactions =>
    db.collection('users').doc(uid).collection('transactions');

  Stream<QuerySnapshot<Map<String, dynamic>>> watch() =>
    transactions.orderBy('createdAt', descending: true).snapshots();

  Future<void> add({required String title, required double amount, required String type, required String category}) =>
    transactions.add({'title': title, 'amount': amount, 'type': type, 'category': category,
      'createdAt': FieldValue.serverTimestamp()});

  Future<void> update(String id, {required String title, required double amount, required String type, required String category}) =>
    transactions.doc(id).update({'title': title, 'amount': amount, 'type': type, 'category': category});

  Future<void> delete(String id) => transactions.doc(id).delete();
}

final service = TransactionService();
