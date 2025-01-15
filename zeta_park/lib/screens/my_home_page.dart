import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/item_detail_screen.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:money2/money2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double gesamtbetrag = 0.00;
  double betrag1 = 0.00;
  double betrag2 = 0.00;
  String selectedBlock = 'Zeta Park Blok 1/1';
  String selectedMonth = 'Ocak';
  int selectedYear = 2025;
  Currency selectedCurrency = Currency.create('TRY', 2, symbol: '₺');
  final TextEditingController _betrag1Controller = TextEditingController();
  final TextEditingController _betrag2Controller = TextEditingController();

  final Map<String, Map<String, Map<int, Map<String, double>>>> blockAmounts =
      {};

  @override
  void dispose() {
    _betrag1Controller.dispose();
    _betrag2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CustomCard(),
                    const SizedBox(height: 16.0),
                    _buildBlockDropdown(),
                    const SizedBox(height: 16.0),
                    _buildMonthYearDropdowns(),
                    const SizedBox(height: 16.0),
                    _buildPaymentCard(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBlockDropdown() {
    final List<String> blocks = _generateBlocks();

    return DropdownButton<String>(
      value: selectedBlock,
      items: blocks.map((String block) {
        return DropdownMenuItem<String>(
          value: block,
          child: Text(block),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedBlock = newValue!;
          _loadAmounts();
        });
      },
      isExpanded: true,
    );
  }

  List<String> _generateBlocks() {
    return List.generate(
      50,
      (i) {
        final int blockNumber = (i ~/ 2) + 1;
        final String suffix = (i % 2 == 0) ? '' : 'a';
        return 'Zeta Park Blok 1/$blockNumber$suffix';
      },
    );
  }

  Widget _buildMonthYearDropdowns() {
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
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
                _loadAmounts();
              });
            },
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
            onChanged: (int? newValue) {
              setState(() {
                selectedYear = newValue!;
                _loadAmounts();
              });
            },
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

  Widget _buildPaymentCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentFields(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _onConfirmPressed,
              child: const Text('Bestätigen'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Site Yönetimi: Fatih Sevindik',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Divider(thickness: 1, color: Colors.grey[300]),
            const SizedBox(height: 8.0),
            const Text(
              'Banka Dekont Giris Bilgileri',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            const Text('Visa\n**** **** **** 4243'),
            Divider(thickness: 1, color: Colors.grey[300]),
            const SizedBox(height: 8.0),
            _buildPaymentSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _betrag1Controller,
            decoration: InputDecoration(
              labelText: 'Aidat Ödemesi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateBetrag1,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: _betrag2Controller,
            decoration: InputDecoration(
              labelText: 'Ek Ödemesi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateBetrag2,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aidat Ödemesi:'),
            Text(
                '${Money.fromInt((betrag1 * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ek Ödeme:'),
            Text(
                '${Money.fromInt((betrag2 * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Toplam Ödeme:'),
            Text(
                '${Money.fromInt((gesamtbetrag * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
      ],
    );
  }

  void _onConfirmPressed() {
    setState(() {
      gesamtbetrag += betrag1 + betrag2;
      _saveAmounts();
      betrag1 = 0.00;
      betrag2 = 0.00;
      _betrag1Controller.clear();
      _betrag2Controller.clear();
    });
    _showConfirmationDialog();
  }

  void _updateBetrag1(String value) {
    setState(() {
      betrag1 = double.tryParse(value) ?? 0.00;
    });
  }

  void _updateBetrag2(String value) {
    setState(() {
      betrag2 = double.tryParse(value) ?? 0.00;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bestätigung'),
          content: const Text('Möchten Sie die Änderungen speichern?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  betrag1 = 0.00;
                  betrag2 = 0.00;
                });
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                      title: selectedBlock,
                      subtitle: 'Aidat ödeme ve Ek Ödeme Bilgileri.',
                      blockAmounts: blockAmounts.map((key, value) {
                        return MapEntry(key, value.map((innerKey, innerValue) {
                          return MapEntry(innerKey,
                              innerValue.map((innerMostKey, innerMostValue) {
                            return MapEntry(
                                innerMostKey,
                                innerMostValue['aidat']! +
                                    innerMostValue['ek']!);
                          }));
                        }));
                      }),
                    ),
                  ),
                );
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  void _saveAmounts() {
    if (!blockAmounts.containsKey(selectedBlock)) {
      blockAmounts[selectedBlock] = {};
    }
    if (!blockAmounts[selectedBlock]!.containsKey(selectedMonth)) {
      blockAmounts[selectedBlock]![selectedMonth] = {};
    }
    blockAmounts[selectedBlock]![selectedMonth]![selectedYear] = {
      'aidat': betrag1,
      'ek': betrag2,
    };
  }

  void _loadAmounts() {
    if (blockAmounts.containsKey(selectedBlock) &&
        blockAmounts[selectedBlock]!.containsKey(selectedMonth) &&
        blockAmounts[selectedBlock]![selectedMonth]!
            .containsKey(selectedYear)) {
      final amounts =
          blockAmounts[selectedBlock]![selectedMonth]![selectedYear]!;
      betrag1 = amounts['aidat'] ?? 0.00;
      betrag2 = amounts['ek'] ?? 0.00;
    } else {
      betrag1 = 0.00;
      betrag2 = 0.00;
    }
  }

  void _processBlockAmounts(Map<String, Map<String, Map<int, double>>> data) {
    // ...function implementation...
  }

  late Map<String, Map<String, Map<int, double>>> adjustedBlockAmounts;

  @override
  void initState() {
    super.initState();
    adjustedBlockAmounts = blockAmounts.map((key, value) {
      return MapEntry(key, value.map((innerKey, innerValue) {
        return MapEntry(innerKey,
            innerValue.map((innerMostKey, innerMostValue) {
          // Assuming you need to extract a specific double value from the innermost map
          double extractedValue =
              innerMostValue['someKey'] ?? 0.0; // Adjust 'someKey' as needed
          return MapEntry(innerMostKey, extractedValue);
        }));
      }));
    });

    // Pass the adjusted argument to the function
    _processBlockAmounts(adjustedBlockAmounts);
  }
}
