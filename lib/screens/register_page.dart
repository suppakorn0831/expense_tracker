import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_helpers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(), password: password.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('สมัครสมาชิก')),
    body: Center(child: SingleChildScrollView(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(padding: const EdgeInsets.all(24), child: Form(
        key: formKey,
        child: Column(children: [
          const Icon(Icons.person_add, size: 70, color: Colors.deepPurple),
          const SizedBox(height: 24),
          TextFormField(controller: email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'อีเมล', border: OutlineInputBorder()),
            validator: (v) => v == null || !v.contains('@') ? 'กรุณากรอกอีเมลให้ถูกต้อง' : null),
          const SizedBox(height: 14),
          TextFormField(controller: password, obscureText: true,
            decoration: const InputDecoration(labelText: 'รหัสผ่าน', border: OutlineInputBorder()),
            validator: (v) => v == null || v.length < 6 ? 'รหัสผ่านอย่างน้อย 6 ตัวอักษร' : null),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: busy ? null : register,
            child: Text(busy ? 'กำลังสมัครสมาชิก...' : 'สมัครสมาชิก'),
          )),
        ]),
      )),
    ))),
  );
}
