// ignore_for_file: library_private_types_in_public_api

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class ItemDetailScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Map<String, Map<String, Map<int, Map<String, double>>>> blockAmounts;

  const ItemDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.blockAmounts,
  });

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int selectedYear = 2025;
  String selectedMonth = 'Januar';
  Currency selectedCurrency = Currency.create('TRY', 2, symbol: '₺');
  final ValueNotifier<List<Map<String, dynamic>>> paymentsNotifier =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _updatePayments();
  }

  void _updatePayments() {
    paymentsNotifier.value = List.generate(
      12,
      (i) {
        final month = _getMonthName(i + 1);
        final amounts = widget.blockAmounts[widget.title]?[month]
                ?[selectedYear] ??
            {'aidat': 0.0, 'ek': 0.0};
        return {
          'month': month,
          'year': selectedYear,
          'aidat': amounts['aidat'] ?? 0.0,
          'ek': amounts['ek'] ?? 0.0,
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> years = List.generate(10, (index) => 2024 + index);
    final List<String> months = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/zeta.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withAlpha(128),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.white.withAlpha(25),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: selectedMonth,
                          dropdownColor: Colors.black.withAlpha(128),
                          style: const TextStyle(color: Colors.white),
                          items: months.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  month,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMonth = newValue!;
                              _updatePayments();
                            });
                          },
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.white.withAlpha(25),
                          ),
                        ),
                        child: DropdownButton<int>(
                          value: selectedYear,
                          dropdownColor: Colors.black.withAlpha(128),
                          style: const TextStyle(color: Colors.white),
                          items: years.map((int year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  year.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedYear = newValue!;
                              _updatePayments();
                            });
                          },
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: paymentsNotifier,
                    builder: (context, payments, _) {
                      return ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return Card(
                            color: Colors.white.withAlpha(25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(12),
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(25),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${payment['month']} ${payment['year']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Aidat Ödeme: ${Money.fromInt((payment['aidat'] * 100).toInt(), code: selectedCurrency.code)}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Ek Ödeme: ${Money.fromInt((payment['ek'] * 100).toInt(), code: selectedCurrency.code)}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      "Januar",
      "Februar",
      "März",
      "April",
      "Mai",
      "Juni",
      "Juli",
      "August",
      "September",
      "Oktober",
      "November",
      "Dezember",
    ];
    return monthNames[month - 1];
  }
}
