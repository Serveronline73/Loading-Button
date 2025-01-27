import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/repository/sharedPreferences.dart';
import 'package:flutter_application_1/screens/item_detail_screen.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
          await SharedPreferencesHelper.loadBlock('selectedBlock') ??
              selectedBlock;
      selectedMonth =
          await SharedPreferencesHelper.loadBlock('selectedMonth') ??
              selectedMonth;
      selectedYear = await SharedPreferencesHelper.loadYear('selectedYear') ??
          selectedYear;
      betrag1 = await SharedPreferencesHelper.loadBetrag('betrag1') ?? betrag1;
      betrag2 = await SharedPreferencesHelper.loadBetrag('betrag2') ?? betrag2;
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
              SharedPreferencesHelper.saveNebenkosten(
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
            " Einzahlungsinformationen",
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
    // Eingabe Felder für die Einzahlung
    return Row(
      children: [
        Expanded(
          // Expanded Widget für die Flexibilität
          child: TextField(
            controller: _betrag1Controller,
            decoration: InputDecoration(
              // labelText: 'Aidat Ödemesi',
              labelText: "Einzahlung NK",
              labelStyle: const TextStyle(
                color: Color(0xFF488AEC),
              ),
              focusColor: Colors.white, // Fokusfarbe des Textfeldes
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateBetrag1, // Funktion zum Update des Betrags
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          // Expanded Widget für die Flexibilität
          child: TextField(
            controller: _betrag2Controller,
            decoration: InputDecoration(
              //labelText: 'Ek Ödemesi',
              labelText: "Nachzuhlung NK",
              labelStyle: const TextStyle(
                color: Color(0xFF488AEC),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateBetrag2, // Funktion zum Update des Betrags
          ),
        ),
      ],
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
    // Ausgabenkarte
    final expenses = _dataManager.getExpenses(selectedMonth,
        selectedYear); // Ausgaben für den ausgewählten Monat und das Jahr

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A3C54), Color(0xFF070F2D)],
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
            spreadRadius: -1, // Schattenbreite
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ausgabenliste',
            style: TextStyle(
              color: Color(0xFF488AEC),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ausgaben für $selectedMonth $selectedYear', // Ausgaben für den ausgewählten Monat und das Jahr
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          context.watch<RoleManager>().admin
              ? Column(
                  children: [
                    TextField(
                      controller: _ausgabeController,
                      decoration: InputDecoration(
                        labelText: 'Ausgabenbetrag',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
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
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
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
                          SharedPreferencesHelper.saveBetrag(
                              'ausgabe', ausgabe);
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
                  ],
                )
              : const SizedBox(),
          if (expenses.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            const Divider(
              thickness: 1,
              color: Color(0xFF488AEC),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Ausgabenliste', // Überschrift der Ausgabenliste
              style: TextStyle(
                color: Color(0xFF488AEC),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Scrollen deaktivieren
              itemCount: expenses.length * 2 - 1, // Anzahl der Ausgaben
              itemBuilder: (context, index) {
                // Ausgaben anzeigen
                if (index.isOdd) {
                  // Wenn ungerade Indexnummer
                  return const Divider(
                    color: Color(0xFF488AEC),
                    thickness: 1,
                    height: 1,
                  );
                }
                final Map<String, dynamic> expense =
                    expenses[index ~/ 2]; // Ausgabenindex
                return Slidable(
                  // Ausgaben mit Slidable-Widget anzeigen
                  endActionPane: context.watch<RoleManager>().admin
                      ? ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _showEditDialog(
                                    expense); // Dialog für Bearbeiten öffnen
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Bearbeiten',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _showDeleteConfirmation(
                                    expense); // Dialog für Löschen öffnen
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Löschen',
                            ),
                          ],
                        )
                      : null,
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      expense['description'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(expense['date'],
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(
                      '${Money.fromInt((expense['amount'] * 100).toInt(), code: selectedCurrency.code)}', // Ausgabenbetrag in Währung umrechnen
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            const Divider(
              thickness: 1,
              color: Color(0xFF488AEC),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Gesamtausgaben für $selectedMonth $selectedYear:', // Gesamtausgaben für den ausgewählten Monat und das Jahr
                    style: const TextStyle(
                      color: Color(0xFF488AEC),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis, // Textüberlauf verhindern
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${Money.fromInt((expenses.fold<double>(0, (sum, expense) => sum + expense['amount']) * 100).toInt(), code: selectedCurrency.code)}', // Gesamtausgaben in Währung umrechnen
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _onConfirmPressed() async {
    // Funktion zum Speichern der Eingaben
    _saveAmounts();
    await SharedPreferencesHelper.saveNebenkosten(
        // Eingaben in SharedPreferences speichern
        'selectedBlock',
        selectedBlock);
    await SharedPreferencesHelper.saveNebenkosten(
        // Eingaben in SharedPreferences speichern
        'selectedMonth',
        selectedMonth);
    await SharedPreferencesHelper.saveYear('selectedYear',
        selectedYear); // Eingaben in SharedPreferences speichern
    await SharedPreferencesHelper.saveBetrag(
        'betrag1', betrag1); // Eingaben in SharedPreferences speichern
    await SharedPreferencesHelper.saveBetrag(
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
    SharedPreferencesHelper.saveBetrag(
        'betrag1', betrag1); // Eingaben in SharedPreferences speichern
  }

  void _updateBetrag2(String value) {
    // Funktion zum Aktualisieren des Betrags
    setState(() {
      betrag2 = double.tryParse(value) ?? 0.00; // Betrag2 als Double parsen
    });
    SharedPreferencesHelper.saveBetrag(
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
      SharedPreferencesHelper.saveBetrag('betrag1', betrag1);
    } else {
      setState(() {
        // Eingaben zurücksetzen
        betrag1 = 0.00; // Betrag1 zurücksetzen
        betrag2 = 0.00; // Betrag2 zurücksetzen
        _betrag1Controller.clear(); // Betrag1-Controller zurücksetzen
        _betrag2Controller.clear(); // Betrag2-Controller zurücksetzen
      });
      SharedPreferencesHelper.saveBetrag(
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
    // Funktion zum Anzeigen des Bearbeitungsdialogs
    final TextEditingController descController = // Beschreibung-Controller
        TextEditingController(
            text:
                expense['description']); // Beschreibung aus der Datenbank laden
    final TextEditingController amountController = // Betrag-Controller
        TextEditingController(
            text:
                expense['amount'].toString()); // Betrag aus der Datenbank laden

    showDialog(
      // Dialog anzeigen
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // AlertDialog anzeigen
          backgroundColor: Colors.grey[900],
          title: const Text('Ausgabe bearbeiten',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Betrag',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Dialog schließen
              child: const Text('Abbrechen',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                // Funktion zum Speichern der Änderungen
                final double? newAmount = double.tryParse(
                    amountController.text); // Neuer Betrag parsen
                if (newAmount != null) {
                  // Wenn neuer Betrag vorhanden ist
                  await _dataManager.updateExpense(
                    // Ausgabe in der Datenbank aktualisieren
                    expense,
                    newAmount,
                    descController.text,
                  );
                  if (mounted) {
                    // Wenn die App aktiv ist
                    Navigator.pop(context); // Dialog schließen
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar anzeigen
                      const SnackBar(
                        content: Text('Ausgabe wurde aktualisiert'),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Speichern',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showDeleteConfirmation(Map<String, dynamic> expense) {
    // Funktion zum Anzeigen des Löschdialogs
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Ausgabe löschen',
              style: TextStyle(color: Colors.white)),
          content: const Text('Möchten Sie diese Ausgabe wirklich löschen?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Dialog schließen
              child: const Text('Abbrechen',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                // Funktion zum Löschen der Ausgabe
                await _dataManager
                    .deleteExpense(expense); // Ausgabe in der Datenbank löschen
                if (mounted) {
                  // Wenn die App aktiv ist
                  Navigator.pop(context); // Dialog schließen
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar anzeigen
                    const SnackBar(
                      // SnackBar mit Nachricht anzeigen
                      content: Text('Ausgabe wurde gelöscht'),
                    ),
                  );
                }
              },
              child: const Text('Löschen', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
