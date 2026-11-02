import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_helpers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool? compact;
  @override
  void initState() { super.initState(); loadPreference(); }
  Future<void> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => compact = prefs.getBool('compactMode') ?? false);
  }
  Future<void> setCompact(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('compactMode', value);
    if (mounted) setState(() => compact = value);
  }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 42)),
    const SizedBox(height: 12),
    Center(child: Text(FirebaseAuth.instance.currentUser?.email ?? '-',
      style: Theme.of(context).textTheme.titleMedium)),
    const SizedBox(height: 24),
    SwitchListTile(title: const Text('แสดงข้อมูลแบบกระชับ'),
      subtitle: Text(compact == true ? 'โหมดกระชับเปิดอยู่ (บันทึกไว้ในเครื่อง)' : 'โหมดกระชับปิดอยู่ (บันทึกไว้ในเครื่อง)'),
      value: compact ?? false, onChanged: compact == null ? null : setCompact),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: () async {
      try { await FirebaseAuth.instance.signOut(); }
      catch (e) { if (context.mounted) showError(context, e); }
    }, icon: const Icon(Icons.logout), label: const Text('ออกจากระบบ')),
  ]);
}
