import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'transaction_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(['ภาพรวม', 'ประวัติ', 'โปรไฟล์'][tab]),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer),
    body: IndexedStack(index: tab, children: const [DashboardPage(), HistoryPage(), ProfilePage()]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'หน้าหลัก'),
        NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'ประวัติ'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'โปรไฟล์'),
      ]),
    floatingActionButton: tab == 2 ? null : FloatingActionButton.extended(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionFormPage())),
      icon: const Icon(Icons.add), label: const Text('เพิ่มรายการ')),
  );
}
