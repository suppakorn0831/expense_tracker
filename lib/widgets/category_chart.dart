import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_helpers.dart';

class CategoryChart extends StatelessWidget {
  final Map<String, double> categories;
  const CategoryChart({
  super.key,
  required this.categories,
});
  @override
  Widget build(BuildContext context) {
    const colors = [Color(0xFF7455AD), Color(0xFFFF9F68), Color(0xFF45A6A0), Color(0xFFEB6B88), Color(0xFF5B8DEF), Color(0xFFE0BD55), Color(0xFF9B8AA5), Color(0xFF8AC46C)];
    final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (total, item) => total + item.value);
    return Column(children: [
      SizedBox(height: 205, child: PieChart(PieChartData(
        centerSpaceRadius: 40,
        sectionsSpace: 3,
        sections: [for (var i = 0; i < entries.length; i++)
          PieChartSectionData(value: entries[i].value, color: colors[i % colors.length], radius: 60,
            title: '${(entries[i].value / total * 100).toStringAsFixed(0)}%',
            titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))],
      ))),
      const SizedBox(height: 12),
      for (var i = 0; i < entries.length; i++)
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
          CircleAvatar(radius: 6, backgroundColor: colors[i % colors.length]),
          const SizedBox(width: 10),
          Expanded(child: Text(entries[i].key)),
          Text(baht(entries[i].value)),
        ])),
    ]);
  }
}
