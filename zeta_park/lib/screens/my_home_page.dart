import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/repository/sharedPreferences.dart';
import 'package:flutter_application_1/screens/item_detail_screen.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:flutter_application_1/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_application_1/widgets/edit_expense_dialog.dart';
import 'package:flutter_application_1/widgets/expenses_card.dart';
import 'package:flutter_application_1/widgets/payment_fields_nk.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

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
  String selectedMonth = 'Januar';
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
    setState(() async {
      selectedBlock =
          await SharedPreferencesRepository.loadBlock('selectedBlock') ??
              selectedBlock;
      selectedMonth =
          await SharedPreferencesRepository.loadBlock('selectedMonth') ??
              selectedMonth;
      selectedYear =
          await SharedPreferencesRepository.loadYear('selectedYear') ??
              selectedYear;
      betrag1 =
          await SharedPreferencesRepository.loadBetrag('betrag1') ?? betrag1;
      betrag2 =
          await SharedPreferencesRepository.loadBetrag('betrag2') ?? betrag2;
      _betrag1Controller.text = betrag1.toString();
      _betrag2Controller.text = betrag2.toString();
      _loadAmounts();
    });
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

  void _navigateToDashboard(BuildContext context) {
    final payments =
        _dataManager.getGroupedPayments(selectedMonth, selectedYear);
    final expenses = _dataManager.getExpenses(selectedMonth, selectedYear);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          payments: payments,
          expenses: expenses,
          selectedMonth: selectedMonth,
          selectedYear: selectedYear,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Einheitliche Hintergrundfarbe
      appBar: AppBar(
        backgroundColor: Colors.black, // Einheitliche AppBar-Farbe
        title: const Text(
          'Zeta Park',
          style: TextStyle(color: Colors.white), // Textfarbe der AppBar
        ),
        // AppBar-Icon zum Ausloggen
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => _navigateToDashboard(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            cardTheme: const CardTheme(
              color: Colors.black, // Hintergrundfarbe der Karten Container
            ),
          ),
          child: Container(
            color: Colors.black, // Einheitliche Hintergrundfarbe
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Column(
                      children: [
                        Text(
                          context.watch<RoleManager>().admin
                              ? "Admin"
                              : "Normaler User",
                          style: const TextStyle(color: Colors.white),
                        ),
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
        ),
      ),
    );
  }

  Widget _buildBlockDropdown() {
    final List<String> blocks = _generateBlocks();

    return context.watch<RoleManager>().admin
        ? DropdownButton<String>(
            value: selectedBlock,
            dropdownColor: Colors.black, // Hintergrundfarbe des Dropdown-Menüs
            style: const TextStyle(
                color: Colors.white), // Textfarbe der Dropdown-Menüs
            items: blocks.map((String block) {
              return DropdownMenuItem<String>(
                value: block,
                child: Text(
                  block,
                  style: const TextStyle(
                      color: Colors.white), // Textfarbe der Dropdown-Menüs
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedBlock = newValue!;
                _loadAmounts();
              });
              SharedPreferencesRepository.saveNebenkosten(
                  'selectedBlock', selectedBlock);
            },
            isExpanded: true,
          )
        : const SizedBox();
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
            dropdownColor: Colors.black, // Hintergrundfarbe des Dropdown-Menüs
            style: const TextStyle(
                color: Colors.white), // Textfarbe der Dropdown-Menüs
            items: months.map((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(
                  month,
                  style: const TextStyle(
                      color: Colors.white), // Textfarbe der Dropdown-Menüs
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
                _loadAmounts();
              });
              SharedPreferencesRepository.saveNebenkosten(
                  'selectedMonth', selectedMonth);
            },
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: DropdownButton<int>(
            value: selectedYear,
            dropdownColor: Colors.black, // Hintergrundfarbe des Dropdown-Menüs
            style: const TextStyle(
                color: Colors.white), // Textfarbe der Dropdown-Menüs
            items: years.map((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(
                  year.toString(),
                  style: const TextStyle(
                      color: Colors.white), // Textfarbe der Dropdown-Menüs
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                selectedYear = newValue!;
                _loadAmounts();
              });
              SharedPreferencesRepository.saveYear(
                  'selectedYear', selectedYear);
            },
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  List<String> _generateMonths() {
    return [
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
  }

  List<int> _generateYears() {
    return List.generate(10, (index) => 2024 + index);
  }

  Widget _buildPaymentCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF070F2D),
            Color(0xFF3A3C54)
          ], // Hintergrundfarbe des Containers
          begin: Alignment.bottomLeft, // Verlauf beginnt unten links
          end: Alignment.topRight, // Verlauf endet oben rechts
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF545A6A)), // Rahmenfarbe
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF488AEC)
                .withAlpha((0.19 * 255).toInt()), // Schattenfarbe
            offset: const Offset(0, 4), // Schattenposition
            blurRadius: 6, // Schattenradius
            spreadRadius: -1, // Schattenverbreitung
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      // Zeile 300 bis 313 sorgt dafür das die Eingabefelder für den Nutzer deaktiviert wird

      child: Column(
        children: [
          context.watch<RoleManager>().admin
              ? Column(
                  children: [
                    paymentFieldsNK(),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      // Bestätigen Button
                      onPressed: _onConfirmPressed,
                      child: const Text('Bestätigen'),
                    )
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 16.0),
          const Text(
            //'Site Yönetimi: Fatih Sevindik',
            "Verwaltung: Fatih Sevindik",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Divider(thickness: 1, color: Colors.grey[300]),
          const SizedBox(height: 8.0),
          const Text(
            //'Banka Dekont Giris Bilgileri',
            " Einzahlung Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          paymentNK(),
        ],
      ),
    );
  }

  Widget paymentFieldsNK() {
    return PaymentFieldsNK(
      betrag1Controller: _betrag1Controller,
      betrag2Controller: _betrag2Controller,
      updateBetrag1: _updateBetrag1,
      updateBetrag2: _updateBetrag2,
    );
  }

  Widget paymentNK() {
    // Zahlungsdetails für die Einzahlung
    final monthlyTotal = getMonthlyTotal();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              //'Aidat Ödemesi:',
              "Nebenkosten Zahlungen:",
              style: TextStyle(color: Color(0xFF488AEC)),
            ),
            Text(
              '${Money.fromInt((betrag1 * 100).toInt(), code: selectedCurrency.code)}', // Betrag1 in Währung umrechnen
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
                //'Ek Ödeme:',
                "Nebenkosten Nachzahlung:",
                style: TextStyle(color: Color(0xFF488AEC))),
            Text(
                '${Money.fromInt((betrag2 * 100).toInt(), code: selectedCurrency.code)}', // Betrag2 in Währung umrechnen
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                //'Toplam Ödeme ($selectedMonth $selectedYear):',
                // // Gesamtbetrag für den Monat und das Jahr
                "Gesamtbetrag ($selectedMonth $selectedYear):",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF488AEC),
                )),
            Text(
                '${Money.fromInt((monthlyTotal * 100).toInt(), code: selectedCurrency.code)}', // Gesamtbetrag in Währung umrechnen
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesCard() {
    return ExpensesCard(
      dataManager: _dataManager,
      selectedMonth: selectedMonth,
      selectedYear: selectedYear,
      selectedCurrency: selectedCurrency,
      ausgabeController: _ausgabeController,
      ausgabeDescriptionController: _ausgabeDescriptionController,
      ausgabe: ausgabe,
      ausgabeDescription: ausgabeDescription,
      onAusgabeChanged: (value) {
        setState(() {
          ausgabe = value;
        });
      },
      onAusgabeDescriptionChanged: (value) {
        setState(() {
          ausgabeDescription = value;
        });
      },
      onSaveExpense: () async {
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
      },
      onShowEditDialog: _showEditDialog,
      onShowDeleteConfirmation: _showDeleteConfirmation,
    );
  }

  void _onConfirmPressed() async {
    // Funktion zum Speichern der Eingaben
    _saveAmounts();
    await SharedPreferencesRepository.saveNebenkosten(
        // Eingaben in SharedPreferences speichern
        'selectedBlock',
        selectedBlock);
    await SharedPreferencesRepository.saveNebenkosten(
        // Eingaben in SharedPreferences speichern
        'selectedMonth',
        selectedMonth);
    await SharedPreferencesRepository.saveYear('selectedYear',
        selectedYear); // Eingaben in SharedPreferences speichern
    await SharedPreferencesRepository.saveBetrag(
        'betrag1', betrag1); // Eingaben in SharedPreferences speichern
    await SharedPreferencesRepository.saveBetrag(
        'betrag2', betrag2); // Eingaben in SharedPreferences speichern
    setState(() {
      betrag1 = 0.00; // Betrag1 zurücksetzen
      betrag2 = 0.00; // Betrag2 zurücksetzen
      _betrag1Controller.clear(); // Betrag1-Controller zurücksetzen
      _betrag2Controller.clear(); // Betrag2-Controller zurücksetzen
    });
    _showConfirmationDialog(); // Bestätigungsdialog anzeigen
  }

  void _updateBetrag1(String value) {
    // Funktion zum Aktualisieren des Betrags
    setState(() {
      betrag1 = double.tryParse(value) ?? 0.00; // Betrag1 als Double parsen
    });
    SharedPreferencesRepository.saveBetrag(
        'betrag1', betrag1); // Eingaben in SharedPreferences speichern
  }

  void _updateBetrag2(String value) {
    // Funktion zum Aktualisieren des Betrags
    setState(() {
      betrag2 = double.tryParse(value) ?? 0.00; // Betrag2 als Double parsen
    });
    SharedPreferencesRepository.saveBetrag(
        'betrag2', betrag2); // Eingaben in SharedPreferences speichern
  }

  void _saveAmounts() {
    // Funktion zum Speichern der Eingaben in der Datenbank
    _dataManager.savePayment(
      // Datenbank-Objekt zum Speichern der Eingaben verwenden
      selectedBlock, // Block speichern
      selectedMonth, // Monat speichern
      selectedYear, // Jahr speichern
      betrag1, // Betrag1 speichern
      betrag2, // Betrag2 speichern
    );
  }

  void _loadAmounts() {
    // Funktion zum Laden der Eingaben aus der Datenbank
    final blockAmounts = _dataManager
        .getBlockAmounts(); // Datenbank-Objekt zum Laden der Eingaben verwenden
    if (blockAmounts.containsKey(
            selectedBlock) && // Wenn Block in der Datenbank vorhanden ist
        blockAmounts[selectedBlock]!.containsKey(
            selectedMonth) && // Wenn Monat in der Datenbank vorhanden ist
        blockAmounts[selectedBlock]![
                selectedMonth]! // Wenn Jahr in der Datenbank vorhanden ist
            .containsKey(selectedYear)) {
      // Wenn Jahr in der Datenbank vorhanden ist
      final amounts = blockAmounts[selectedBlock]![selectedMonth]![
          selectedYear]!; // Eingaben aus der Datenbank laden
      setState(() {
        betrag1 = amounts['aidat'] ?? 0.00;
        betrag2 = amounts['ek'] ?? 0.00;
        _betrag1Controller.text = betrag1.toString();
        _betrag2Controller.text = betrag2.toString();
      });
      SharedPreferencesRepository.saveBetrag('betrag1', betrag1);
    } else {
      setState(() {
        // Eingaben zurücksetzen
        betrag1 = 0.00; // Betrag1 zurücksetzen
        betrag2 = 0.00; // Betrag2 zurücksetzen
        _betrag1Controller.clear(); // Betrag1-Controller zurücksetzen
        _betrag2Controller.clear(); // Betrag2-Controller zurücksetzen
      });
      SharedPreferencesRepository.saveBetrag(
          'betrag1', betrag1); // Eingaben in SharedPreferences speichern
    }
  }

  void _showConfirmationDialog() {
    // Funktion zum Anzeigen des Bestätigungsdialogs
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // AlertDialog anzeigen
          title: const Text('Bestätigung'),
          content: const Text('Möchten Sie die Änderungen speichern?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
                Navigator.push(
                  // Neue Seite öffnen
                  context,
                  MaterialPageRoute(
                    // Navigation zur neuen Seite
                    builder: (context) => ItemDetailScreen(
                      // ItemDetailScreen anzeigen
                      title: selectedBlock,
                      //subtitle: 'Aidat ödeme ve Ek Ödeme Bilgileri.',
                      subtitle: 'Nebenkosten- und Nachzahlungsinformationen.',
                      blockAmounts: _dataManager
                          .getBlockAmounts(), // Datenbank-Objekt übergeben
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

  void _showEditDialog(Map<String, dynamic> expense) {
    final descController = TextEditingController(text: expense['description']);
    final amountController =
        TextEditingController(text: expense['amount'].toString());

    EditExpenseDialog(
      context: context,
      descController: descController,
      amountController: amountController,
      updateExpense: _dataManager.updateExpense,
      expense: expense,
      onUpdate: () {
        if (mounted) {
          setState(() {});
        }
      },
    ).show();
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showDeleteConfirmation(Map<String, dynamic> expense) {
    DeleteConfirmationDialog(
      context: context,
      deleteExpense: _dataManager.deleteExpense,
      onDelete: () {
        if (mounted) {
          setState(() {
            _dataManager.loadData();
          });
        }
      },
    ).show(expense);
  }
}
