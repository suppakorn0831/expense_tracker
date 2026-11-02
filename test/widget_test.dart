import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('Expense Tracker app class exists', (tester) async {
    expect(const ExpenseApp(), isA<Widget>());
  });
}