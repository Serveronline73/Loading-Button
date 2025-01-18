import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/repository/sharedPreferences.dart';
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
  double ausgabe = 0.00;
  String ausgabeDescription = '';
  String selectedBlock = 'Zeta Park Blok 1/1';
  String selectedMonth = 'Ocak';
  int selectedYear = 2025;
  Currency selectedCurrency = Currency.create('TRY', 2, symbol: '₺');

  final TextEditingController _betrag1Controller = TextEditingController();
  final TextEditingController _betrag2Controller = TextEditingController();
  final TextEditingController _ausgabeController = TextEditingController();
  final TextEditingController _ausgabeDescriptionController =
      TextEditingController();
  final DataManager _dataManager = DataManager();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _dataManager.loadData();
    selectedBlock = await SharedPreferencesHelper.loadBlock('selectedBlock') ??
        selectedBlock;
    selectedMonth = await SharedPreferencesHelper.loadBlock('selectedMonth') ??
        selectedMonth;
    selectedYear =
        await SharedPreferencesHelper.loadYear('selectedYear') ?? selectedYear;
    betrag1 = await SharedPreferencesHelper.loadBetrag('betrag1') ?? betrag1;
    betrag2 = await SharedPreferencesHelper.loadBetrag('betrag2') ?? betrag2;
    _betrag1Controller.text = betrag1.toString();
    _betrag2Controller.text = betrag2.toString();
    _loadAmounts();
  }

  double getMonthlyTotal() {
    double total = 0.0;
    final blockAmounts = _dataManager.getBlockAmounts();
    blockAmounts.forEach((block, monthData) {
      if (monthData.containsKey(selectedMonth) &&
          monthData[selectedMonth]!.containsKey(selectedYear)) {
        var amounts = monthData[selectedMonth]![selectedYear]!;
        total += (amounts['aidat'] ?? 0.0) + (amounts['ek'] ?? 0.0);
      }
    });
    return total;
  }

  @override
  void dispose() {
    _betrag1Controller.dispose();
    _betrag2Controller.dispose();
    _ausgabeController.dispose();
    _ausgabeDescriptionController.dispose();
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
                    const SizedBox(height: 16.0),
                    _buildExpensesCard(),
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
        SharedPreferencesHelper.saveNebenkosten('selectedBlock', selectedBlock);
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
              SharedPreferencesHelper.saveNebenkosten(
                  'selectedMonth', selectedMonth);
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
              SharedPreferencesHelper.saveYear('selectedYear', selectedYear);
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
            paymentFieldsNK(),
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
            // const Text('Visa\n**** **** **** 4243'),
            // Divider(thickness: 1, color: Colors.grey[300]),
            // const SizedBox(height: 8.0),
            paymentNK(),
          ],
        ),
      ),
    );
  }

  Widget paymentFieldsNK() {
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

  Widget paymentNK() {
    final monthlyTotal = getMonthlyTotal();
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
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Toplam Ödeme ($selectedMonth $selectedYear):'),
            Text(
                '${Money.fromInt((monthlyTotal * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesCard() {
    final expenses = _dataManager.getExpenses(selectedMonth, selectedYear);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ausgaben für $selectedMonth $selectedYear',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ausgabeController,
              decoration: InputDecoration(
                labelText: 'Ausgabenbetrag',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  ausgabe = double.tryParse(value) ?? 0.00;
                });
                SharedPreferencesHelper.saveBetrag('ausgabe', ausgabe);
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ausgabeDescriptionController,
              decoration: InputDecoration(
                labelText: 'Beschreibung',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  ausgabeDescription = value;
                });
                SharedPreferencesHelper.saveNebenkosten(
                    'ausgabeDescription', ausgabeDescription);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (ausgabe > 0 && ausgabeDescription.isNotEmpty) {
                  final now = DateTime.now();
                  await _dataManager.saveExpense(
                    ausgabe,
                    ausgabeDescription,
                    '${now.day}.${now.month}.${now.year}',
                    selectedMonth,
                    selectedYear,
                  );
                  setState(() {
                    ausgabe = 0.00;
                    ausgabeDescription = '';
                    _ausgabeController.clear();
                    _ausgabeDescriptionController.clear();
                  });
                  SharedPreferencesHelper.saveBetrag('ausgabe', ausgabe);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ausgabe wurde gespeichert'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Ausgabe speichern'),
            ),
            if (expenses.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              const Text(
                'Ausgabenliste',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Text(expense['description']),
                    subtitle: Text(expense['date']),
                    trailing: Text(
                      '${Money.fromInt((expense['amount'] * 100).toInt(), code: selectedCurrency.code)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Divider(thickness: 1, color: Colors.grey[300]),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gesamtausgaben für $selectedMonth $selectedYear:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${Money.fromInt((expenses.fold<double>(0, (sum, expense) => sum + expense['amount']) * 100).toInt(), code: selectedCurrency.code)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onConfirmPressed() async {
    _saveAmounts();
    await SharedPreferencesHelper.saveNebenkosten(
        'selectedBlock', selectedBlock);
    await SharedPreferencesHelper.saveNebenkosten(
        'selectedMonth', selectedMonth);
    await SharedPreferencesHelper.saveYear('selectedYear', selectedYear);
    await SharedPreferencesHelper.saveBetrag('betrag1', betrag1);
    await SharedPreferencesHelper.saveBetrag('betrag2', betrag2);
    setState(() {
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
    SharedPreferencesHelper.saveBetrag('betrag1', betrag1);
  }

  void _updateBetrag2(String value) {
    setState(() {
      betrag2 = double.tryParse(value) ?? 0.00;
    });
    SharedPreferencesHelper.saveBetrag('betrag2', betrag2);
  }

  void _saveAmounts() {
    _dataManager.savePayment(
      selectedBlock,
      selectedMonth,
      selectedYear,
      betrag1,
      betrag2,
    );
  }

  void _loadAmounts() {
    final blockAmounts = _dataManager.getBlockAmounts();
    if (blockAmounts.containsKey(selectedBlock) &&
        blockAmounts[selectedBlock]!.containsKey(selectedMonth) &&
        blockAmounts[selectedBlock]![selectedMonth]!
            .containsKey(selectedYear)) {
      final amounts =
          blockAmounts[selectedBlock]![selectedMonth]![selectedYear]!;
      setState(() {
        betrag1 = amounts['aidat'] ?? 0.00;
        betrag2 = amounts['ek'] ?? 0.00;
        _betrag1Controller.text = betrag1.toString();
        _betrag2Controller.text = betrag2.toString();
      });
      SharedPreferencesHelper.saveBetrag('betrag1', betrag1);
    } else {
      setState(() {
        betrag1 = 0.00;
        betrag2 = 0.00;
        _betrag1Controller.clear();
        _betrag2Controller.clear();
      });
      SharedPreferencesHelper.saveBetrag('betrag1', betrag1);
    }
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
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                      title: selectedBlock,
                      subtitle: 'Aidat ödeme ve Ek Ödeme Bilgileri.',
                      blockAmounts: _dataManager.getBlockAmounts(),
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
}
