import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Map<String, double> payments;
  final List<Map<String, dynamic>> expenses;
  final String selectedMonth;
  final int selectedYear;

  const DashboardScreen({
    super.key,
    required this.payments,
    required this.expenses,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    final paymentData = _createPaymentData();
    final expenseData = _createExpenseData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildStatisticCard(
              context,
              "Einzahlungs Statistik",
              'Einzahlungen für $selectedMonth $selectedYear',
              paymentData,
            ),
            const SizedBox(height: 16),
            _buildStatisticCard(
              context,
              'Ausgaben Statistik',
              'Ausgaben für $selectedMonth $selectedYear',
              expenseData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(BuildContext context, String title,
      String subtitle, List<BarChartGroupData> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: data,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final paymentCount = payments.length;
                          return Text(
                            paymentCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _createPaymentData() {
    return payments.entries.map((entry) {
      final date = entry.key; // Datum des Zahlungseingangs
      final amount = entry.value;
      final day =
          int.tryParse(date.split('.')[0]) ?? 0; // Tag des Monats als x-Wert
      final isNachzahlung =
          date.contains('Nachzahlung'); // Check if it's a "Nachzahlung"
      return BarChartGroupData(
        x: day, // Tag des Monats als x-Wert
        barRods: [
          BarChartRodData(
            toY: amount,
            color: isNachzahlung
                ? Colors.red
                : Colors.blue, // Red for "Nachzahlung", blue otherwise
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _createExpenseData() {
    return expenses.asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value['amount'];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: Colors.red,
            width: 16,
          ),
        ],
      );
    }).toList();
  }
}
