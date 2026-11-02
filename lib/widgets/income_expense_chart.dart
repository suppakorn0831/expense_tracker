import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseChart extends StatelessWidget {
  final double income;
  final double expense;
  const IncomeExpenseChart({
  super.key,
  required this.income,
  required this.expense,
});
  @override
  Widget build(BuildContext context) {
    final maxAmount = income > expense ? income : expense;
    if (maxAmount <= 0) return const Center(child: Text('เพิ่มรายการเพื่อดูกราฟ'));
    return BarChart(BarChartData(
      maxY: maxAmount * 1.2,
      alignment: BarChartAlignment.spaceAround,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28,
          getTitlesWidget: (value, meta) => Padding(padding: const EdgeInsets.only(top: 6),
            child: Text(value == 0 ? 'รายรับ' : 'รายจ่าย')))),
      ),
      barGroups: [
        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: income, width: 52, color: Colors.green, borderRadius: BorderRadius.circular(8))]),
        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: expense, width: 52, color: Colors.redAccent, borderRadius: BorderRadius.circular(8))]),
      ],
    ));
  }
}
