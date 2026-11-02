import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String errorText(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use': return 'อีเมลนี้ถูกใช้งานแล้ว';
      case 'invalid-email': return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'weak-password': return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      case 'invalid-credential': return 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
      case 'user-not-found': return 'ไม่พบบัญชีผู้ใช้';
      case 'wrong-password': return 'รหัสผ่านไม่ถูกต้อง';
    }
  }
  return 'เกิดข้อผิดพลาด: $error';
}

void showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(error))));
}

final money = NumberFormat('#,##0.00', 'en_US');
String baht(double n) => '${money.format(n)} บาท';
