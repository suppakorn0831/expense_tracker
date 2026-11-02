import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_helpers.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text,
      );
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: SingleChildScrollView(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(padding: const EdgeInsets.all(24), child: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.account_balance_wallet, size: 80, color: Colors.deepPurple),
          const SizedBox(height: 12),
          Text('Expense Tracker', style: Theme.of(context).textTheme.headlineMedium),
          const Text('จัดการรายรับรายจ่ายของคุณ'),
          const SizedBox(height: 32),
          TextFormField(controller: email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'อีเมล', border: OutlineInputBorder()),
            validator: (v) => v == null || !v.contains('@') ? 'กรุณากรอกอีเมลให้ถูกต้อง' : null),
          const SizedBox(height: 14),
          TextFormField(controller: password, obscureText: true,
            decoration: const InputDecoration(labelText: 'รหัสผ่าน', border: OutlineInputBorder()),
            validator: (v) => v == null || v.length < 6 ? 'รหัสผ่านอย่างน้อย 6 ตัวอักษร' : null),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: busy ? null : login,
            child: Text(busy ? 'กำลังเข้าสู่ระบบ...' : 'เข้าสู่ระบบ'),
          )),
          TextButton(onPressed: busy ? null : () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('สมัครสมาชิก')),
        ]),
      )),
    ))),
  );
}
