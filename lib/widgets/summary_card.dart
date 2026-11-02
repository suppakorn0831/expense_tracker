import 'package:flutter/material.dart';
import '../utils/app_helpers.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  const SummaryCard({
  super.key,
  required this.label,
  required this.value,
  required this.icon,
  required this.color,
});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14),
    child: Column(children: [Icon(icon, color: color), Text(label),
      FittedBox(child: Text(baht(value), style: const TextStyle(fontWeight: FontWeight.bold)))])));
}
