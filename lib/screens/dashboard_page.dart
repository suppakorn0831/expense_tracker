import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../utils/app_helpers.dart';
import '../utils/categories.dart';
import '../widgets/income_expense_chart.dart';
import '../widgets/category_chart.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: service.watch(),
    builder: (context, snapshot) {
      if (snapshot.hasError) return Center(child: Text('โหลดข้อมูลไม่สำเร็จ: ${snapshot.error}'));
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      double income = 0, expense = 0;
      final categories = <String, double>{};
      for (final doc in snapshot.data!.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0;
        if (data['type'] == 'income') {
          income += amount;
        } else {
          expense += amount;
          final category = categoryOf(data);
          categories.update(category, (value) => value + amount, ifAbsent: () => amount);
        }
      }
      final docs = snapshot.data!.docs;
      return ListView(padding: const EdgeInsets.all(18), children: [
        Text('สรุปการเงินของคุณ', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7251B5), Color(0xFF9C80D2)]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('ยอดคงเหลือทั้งหมด', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            FittedBox(child: Text(baht(income - expense), style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            const Text('รายรับ - รายจ่ายทั้งหมด', style: TextStyle(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: SummaryCard(label: 'รายรับ', value: income, icon: Icons.south_west, color: Colors.green)),
          Expanded(child: SummaryCard(label: 'รายจ่าย', value: expense, icon: Icons.north_east, color: Colors.red)),
        ]),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('เปรียบเทียบรายรับ–รายจ่าย', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 18),
          SizedBox(height: 190, child: IncomeExpenseChart(income: income, expense: expense)),
        ]))),
        const SizedBox(height: 10),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('รายจ่ายตามหมวดหมู่', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          if (categories.isEmpty) const SizedBox(height: 100, child: Center(child: Text('ยังไม่มีข้อมูลรายจ่าย')))
          else CategoryChart(categories: categories),
        ]))),
        const SizedBox(height: 18),
        Text('รายการล่าสุด', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (docs.isEmpty) const Text('ยังไม่มีรายการ กด + เพื่อเพิ่มรายการแรก'),
        ...docs.take(5).map((doc) => TransactionTile(doc: doc)),
        const SizedBox(height: 60),
      ]);
    },
  );
}
