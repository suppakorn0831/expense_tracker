import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: service.watch(),
    builder: (context, snapshot) {
      if (snapshot.hasError) return Center(child: Text('โหลดข้อมูลไม่สำเร็จ: ${snapshot.error}'));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final docs = snapshot.data!.docs;
      if (docs.isEmpty) return const Center(child: Text('ยังไม่มีประวัติรายการ'));
      return ListView.builder(padding: const EdgeInsets.all(12), itemCount: docs.length,
        itemBuilder: (context, i) => TransactionTile(doc: docs[i]));
    },
  );
}
