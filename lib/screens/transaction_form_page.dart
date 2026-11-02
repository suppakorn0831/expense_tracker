import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../utils/categories.dart';
import '../utils/app_helpers.dart';

class TransactionFormPage extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? initial;
  const TransactionFormPage({super.key, this.id, this.initial});
  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController amount;
  late String type;
  late String category;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.initial?['title']?.toString() ?? '');
    amount = TextEditingController(text: widget.initial?['amount']?.toString() ?? '');
    type = widget.initial?['type'] == 'income' ? 'income' : 'expense';
    category = categoryOf(widget.initial ?? {});
    if (!(type == 'income' ? incomeCategories : expenseCategories).contains(category)) category = 'อื่น ๆ';
  }
  @override
  void dispose() { title.dispose(); amount.dispose(); super.dispose(); }
  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      final value = double.parse(amount.text.trim());
      if (widget.id == null) {
        await service.add(title: title.text.trim(), amount: value, type: type, category: category);
      } else {
        await service.update(widget.id!, title: title.text.trim(), amount: value, type: type, category: category);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.id == null ? 'เพิ่มรายการ' : 'แก้ไขรายการ')),
    body: Center(child: SingleChildScrollView(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(padding: const EdgeInsets.all(20), child: Form(
        key: formKey, child: Column(children: [
          DropdownButtonFormField<String>(
            initialValue: type,
            decoration: const InputDecoration(labelText: 'ประเภทรายการ', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'income', child: Text('รายรับ')),
              DropdownMenuItem(value: 'expense', child: Text('รายจ่าย')),
            ], onChanged: (v) => setState(() { type = v ?? 'expense'; category = 'อื่น ๆ'; })),
           const SizedBox(height: 16),
           DropdownButtonFormField<String>(
             key: ValueKey(type),
             initialValue: category,
             decoration: const InputDecoration(labelText: 'หมวดหมู่', border: OutlineInputBorder()),
             items: (type == 'income' ? incomeCategories : expenseCategories)
                 .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
             onChanged: (v) => setState(() => category = v ?? 'อื่น ๆ')),
          const SizedBox(height: 16),
          TextFormField(controller: title,
            decoration: const InputDecoration(labelText: 'ชื่อรายการ เช่น ค่าข้าว', border: OutlineInputBorder()),
            validator: (v) => v == null || v.trim().isEmpty ? 'กรุณากรอกชื่อรายการ' : null),
          const SizedBox(height: 16),
          TextFormField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'จำนวนเงิน (บาท)', border: OutlineInputBorder()),
            validator: (v) {
              final n = double.tryParse(v?.trim() ?? '');
              return n == null || !n.isFinite || n <= 0 ? 'กรุณากรอกจำนวนเงินมากกว่า 0' : null;
            }),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: busy ? null : save, child: Text(busy ? 'กำลังบันทึก...' : 'บันทึก'))),
        ]),
      )),
    ))),
  );
}
