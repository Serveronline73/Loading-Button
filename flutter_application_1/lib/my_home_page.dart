import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    double gesamtsumme = gesamtbetrag + betrag1 + betrag2;

    final List<String> blocks = List.generate(
      50,
      (i) {
        final int blockNumber = (i ~/ 2) + 1;
        final String suffix = (i % 2 == 0) ? '' : 'a';
        return 'Zeta Park Blok 1/$blockNumber$suffix';
      },
    );

    final List<String> months = [
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

    final List<int> years = List.generate(10, (index) => 2024 + index);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomCard(),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
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
                  // Setze die Beträge für den ausgewählten Block
                  betrag1 = 0.00;
                  betrag2 = 0.00;
                });
              },
              isExpanded: true,
            ),
            const SizedBox(height: 16.0),
            Row(
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
                      });
                    },
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Aidat Ödemesi'),
              keyboardType: TextInputType.number,
              onChanged: _updateBetrag1,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Ek Ödemesi'),
              keyboardType: TextInputType.number,
              onChanged: _updateBetrag2,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Site Yönetimi: Fatih Sevindik',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            //const Text('221B Baker Street, W1U 8ED'),
            Divider(thickness: 1, color: Colors.grey[300]),
            const SizedBox(height: 8.0),

            // PAYMENT METHOD
            // const Text(
            //   'Banka Dekont Giris Bilgileri',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // ),
            // const SizedBox(height: 8.0),
            // const Text('Visa\n**** **** **** 4243'),
            // Divider(thickness: 1, color: Colors.grey[300]),
            // const SizedBox(height: 8.0),

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
                    '${Money.fromInt((gesamtsumme * 100).toInt(), code: selectedCurrency.code)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
