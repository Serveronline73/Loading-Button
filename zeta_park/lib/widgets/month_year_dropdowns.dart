import 'package:flutter/material.dart';

class MonthYearDropdowns extends StatelessWidget {
  final String selectedMonth;
  final int selectedYear;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const MonthYearDropdowns({
    Key? key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> months = _generateMonths();
    final List<int> years = _generateYears();

    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            value: selectedMonth,
            items: months.map((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(month),
              );
            }).toList(),
            onChanged: onMonthChanged,
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: DropdownButton<int>(
            value: selectedYear,
            items: years.map((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: onYearChanged,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  List<String> _generateMonths() {
    return [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
  }

  List<int> _generateYears() {
    return List.generate(10, (index) => 2024 + index);
  }
}
