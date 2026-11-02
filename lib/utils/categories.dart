import 'package:flutter/material.dart';

const expenseCategories = ['อาหาร', 'เดินทาง', 'ช้อปปิ้ง', 'ที่พัก', 'บิล/ค่าน้ำไฟ', 'สุขภาพ', 'การศึกษา', 'อื่น ๆ'];
const incomeCategories = ['เงินเดือน', 'เงินจากครอบครัว', 'งานเสริม', 'ของขวัญ', 'อื่น ๆ'];

String categoryOf(Map<String, dynamic> data) {
  final category = data['category'];
  return category is String && category.trim().isNotEmpty ? category : 'อื่น ๆ';
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'อาหาร': return Icons.restaurant;
    case 'เดินทาง': return Icons.directions_bus;
    case 'ช้อปปิ้ง': return Icons.shopping_bag;
    case 'ที่พัก': return Icons.home;
    case 'บิล/ค่าน้ำไฟ': return Icons.receipt_long;
    case 'สุขภาพ': return Icons.favorite;
    case 'การศึกษา': return Icons.school;
    case 'เงินเดือน': return Icons.work;
    case 'เงินจากครอบครัว': return Icons.volunteer_activism;
    case 'งานเสริม': return Icons.laptop;
    case 'ของขวัญ': return Icons.card_giftcard;
    default: return Icons.wallet;
  }
}
