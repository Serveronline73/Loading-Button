import 'dart:convert';
import 'package:flutter_application_1/repository/firestore_repository.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  List<Map<String, dynamic>> expenses = [];
  Map<String, Map<String, Map<int, Map<String, double>>>> blockAmounts = {};
  final FirebaseRepository _firebaseRepo = FirebaseRepository();

  // Laden der Ausgabenliste
  Future<void> loadExpenses() async {
    try {
      expenses = await _firebaseRepo.loadExpenses();
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }

  Future<void> loadData() async {
    await loadExpenses();
    await loadPayments();
  }

  Future<void> deleteExpense(Map<String, dynamic> expense) async {
    try {
      // Lösche die Ausgabe aus der Liste
      expenses.remove(expense);

      // Lösche auch die Ausgabe in Firebase
      await _firebaseRepo.deleteExpense(expense);

      print('Expense deleted locally and from Firebase');
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<void> updateExpense(Map<String, dynamic> expense, double newAmount,
      String newDescription) async {
    final int index = expenses.indexOf(expense);
    if (index != -1) {
      // Aktualisiere die Ausgabe in der lokalen Liste
      expenses[index]['amount'] = newAmount;
      expenses[index]['description'] = newDescription;

      try {
        // Aktualisiere auch die Ausgabe in Firebase
        await _firebaseRepo.updateExpense(expense, newAmount, newDescription);
        print('Expense updated locally and in Firebase');
      } catch (e) {
        print('Error updating expense: $e');
      }
    }
  }

  // Laden der Zahlungen
  Future<void> loadPayments() async {
    try {
      final payments = await _firebaseRepo.loadPayments();
      blockAmounts = _mapPaymentsToBlockAmounts(payments);
    } catch (e) {
      print('Error loading payments: $e');
    }
  }

  Map<String, Map<String, Map<int, Map<String, double>>>>
      _mapPaymentsToBlockAmounts(List<Map<String, dynamic>> payments) {
    final Map<String, Map<String, Map<int, Map<String, double>>>> blockMap = {};
    for (var payment in payments) {
      String block = payment['block'];
      String month = payment['month'];
      int year = payment['year'];
      double aidat = payment['aidat'];
      double ek = payment['ek'];

      blockMap.putIfAbsent(block, () => {});
      blockMap[block]!.putIfAbsent(month, () => {});
      blockMap[block]![month]!.putIfAbsent(year, () => {});

      blockMap[block]![month]![year] = {
        'aidat': aidat,
        'ek': ek,
      };
    }
    return blockMap;
  }

  // Speichern der Ausgaben
  Future<void> saveExpense(double amount, String description, String date,
      String month, int year) async {
    await _firebaseRepo.saveExpense(amount, description, date, month, year);
    expenses.add({
      'amount': amount,
      'description': description,
      'date': date,
      'month': month,
      'year': year,
    });
  }

  // Ausgabenliste Monat und Jahr
  List<Map<String, dynamic>> getExpenses(String month, int year) {
    return expenses
        .where(
            (expense) => expense['month'] == month && expense['year'] == year)
        .toList();
  }

  // Speichern der Zahlungen
  Future<void> savePayment(
      String block, String month, int year, double aidat, double ek) async {
    await _firebaseRepo.savePayment(block, month, year, aidat, ek);
    blockAmounts.putIfAbsent(block, () => {});
    blockAmounts[block]!.putIfAbsent(month, () => {});
    blockAmounts[block]![month]!.putIfAbsent(year, () => {});

    blockAmounts[block]![month]![year] = {
      'aidat': aidat,
      'ek': ek,
    };
  }

  Map<String, Map<String, Map<int, Map<String, double>>>> getBlockAmounts() {
    return blockAmounts;
  }

  Future<void> saveNebenkosten(String key, String value) async {
    // Dieser Abschnitt kann angepasst werden, um Nebenkosten zu speichern
    print('Saving additional costs: $key = $value');
  }

  // Future<void> deleteExpense(Map<String, dynamic> expense) async {
  //   expenses.remove(expense);
  //   // Firebase löschen wäre hier ebenfalls möglich
  //   // z.B. await _firebaseRepo.deleteExpense(expense);
  // }

  // Future<void> updateExpense(Map<String, dynamic> expense, double newAmount,
  //     String newDescription) async {
  //   final int index = expenses.indexOf(expense);
  //   if (index != -1) {
  //     expenses[index]['amount'] = newAmount;
  //     expenses[index]['description'] = newDescription;
  //     // Firebase aktualisieren könnte auch hier eingebaut werden
  //   }
  // }

  Map<int, double> getPayments(String month, int year) {
    // Beispiel-Daten, ersetzen Sie dies durch echte Daten aus Firebase
    return {
      0: 5.0,
      1: 25.0,
      2: 100.0,
      3: 75.0,
    };
  }

  Map<int, double> getExpensesData() {
    // Beispiel-Daten, ersetzen Sie dies durch echte Daten aus Firebase
    return {
      0: 10.0,
      1: 50.0,
      2: 200.0,
      3: 150.0,
    };
  }

  Map<String, double> getGroupedPayments(String month, int year) {
    final payments = <String, double>{};
    blockAmounts.forEach((block, monthData) {
      if (monthData.containsKey(month) && monthData[month]!.containsKey(year)) {
        final amounts = monthData[month]![year]!;
        amounts.forEach((date, amount) {
          if (payments.containsKey(date)) {
            payments[date] = payments[date]! + amount;
          } else {
            payments[date] = amount;
          }
        });
      }
    });
    return payments;
  }
}
