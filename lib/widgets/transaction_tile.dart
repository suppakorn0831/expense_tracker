import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/categories.dart';
import '../utils/app_helpers.dart';
import '../services/transaction_service.dart';
import '../screens/transaction_form_page.dart';

class TransactionTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const TransactionTile({super.key, required this.doc});
  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final isIncome = data['type'] == 'income';
    final amount = (data['amount'] as num?)?.toDouble() ?? 0;
    final timestamp = data['createdAt'];
    final date = timestamp is Timestamp ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate()) : 'กำลังบันทึกเวลา';
    return Card(child: ListTile(
      leading: CircleAvatar(child: Icon(categoryIcon(categoryOf(data)))),
      title: Text(data['title']?.toString() ?? '-'),
      subtitle: Text('${categoryOf(data)} • $date'),
      trailing: Text('${isIncome ? '+' : '-'}${baht(amount)}',
        style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => TransactionFormPage(id: doc.id, initial: data))),
      onLongPress: () async {
        final confirm = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
          title: const Text('ลบรายการ?'), content: const Text('ต้องการลบรายการนี้หรือไม่'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('ยกเลิก')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('ลบ')),
          ]));
        if (confirm == true) {
          try { await service.delete(doc.id); }
          catch (e) { if (context.mounted) showError(context, e); }
        }
      },
    ));
  }
}
