import 'dart:convert';

import 'package:flutter_application_1/repository/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  List<Map<String, dynamic>> expenses = [];
  Map<String, Map<String, Map<int, Map<String, double>>>> blockAmounts = {};

  // Laden der Ausgabenliste
  Future<void> loadExpenses() async {
    try {
      final expensesJson = await SharedPreferencesRepository.loadExpenses();
      if (expensesJson != null) {
        expenses = List<Map<String, dynamic>>.from(
            jsonDecode(expensesJson).map((x) => Map<String, dynamic>.from(x)));
      }
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }

  Future<void> loadData() async {
    await loadExpenses();
    await loadPayments();
  }

  // Laden der Zahlungen
  Future<void> loadPayments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = prefs.getString('payments');
      if (paymentsJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(paymentsJson);
        blockAmounts = Map<String, Map<String, Map<int, Map<String, double>>>>.from(
            decoded.map((key, value) => MapEntry(
                key,
                Map<String, Map<int, Map<String, double>>>.from(
                    (value as Map<String, dynamic>).map((monthKey, monthValue) => MapEntry(
                        monthKey,
                        Map<int, Map<String, double>>.from((monthValue as Map<String, dynamic>)
                            .map((yearKey, yearValue) => MapEntry(int.parse(yearKey), Map<String, double>.from(yearValue as Map<String, dynamic>))))))))));
      }
    } catch (e) {
      print('Error loading payments: $e');
    }
  }

  // Speichern der Ausgaben
  Future<void> saveExpense(double amount, String description, String date,
      String month, int year) async {
    expenses.add({
      'amount': amount,
      'description': description,
      'date': date,
      'month': month,
      'year': year,
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('expenses', jsonEncode(expenses));
    } catch (e) {
      print('Error saving expense: $e');
    }
  }

  // Ausgabenliste Monat und Jahr
  List<Map<String, dynamic>> getExpenses(String month, int year) {
    return expenses
        .where(
            (expense) => expense['month'] == month && expense['year'] == year)
        .toList();
  }

  Map<String, dynamic> _serializePaymentData() {
    final Map<String, dynamic> serialized = {};
    blockAmounts.forEach((block, monthData) {
      serialized[block] = {};
      monthData.forEach((month, yearData) {
        serialized[block][month] = {};
        yearData.forEach((year, amounts) {
          // Convert year to string and ensure amounts are serializable
          serialized[block][month][year.toString()] = {
            'aidat': amounts['aidat']?.toDouble() ?? 0.0,
            'ek': amounts['ek']?.toDouble() ?? 0.0,
          };
        });
      });
    });
    return serialized;
  }

  Future<void> savePayment(
      String block, String month, int year, double aidat, double ek) async {
    try {
      // Initialize nested maps safely
      blockAmounts.putIfAbsent(block, () => {});
      blockAmounts[block]!.putIfAbsent(month, () => {});
      blockAmounts[block]![month]!.putIfAbsent(year, () => {});

      // Save the payment
      blockAmounts[block]![month]![year] = {
        'aidat': aidat,
        'ek': ek,
      };

      // Serialize and save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final serializedData = _serializePaymentData();
      await prefs.setString('payments', jsonEncode(serializedData));
    } catch (e) {
      print('Fehler beim Speichern der Zahlung: $e');
      rethrow; // Optional: rethrow to handle error in UI
    }
  }

  Map<String, Map<String, Map<int, Map<String, double>>>> getBlockAmounts() {
    return blockAmounts;
  }

  Future<void> saveNebenkosten(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      print('Error saving additional costs: $e');
    }
  }

  Future<void> deleteExpense(Map<String, dynamic> expense) async {
    expenses.remove(expense);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('expenses', jsonEncode(expenses));
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  Future<void> updateExpense(Map<String, dynamic> expense, double newAmount,
      String newDescription) async {
    final int index = expenses.indexOf(expense);
    if (index != -1) {
      expenses[index]['amount'] = newAmount;
      expenses[index]['description'] = newDescription;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('expenses', jsonEncode(expenses));
      } catch (e) {
        print('Error updating expense: $e');
      }
    }
  }

  Map<int, double> getPayments(String month, int year) {
    // Beispiel-Daten, ersetzen Sie dies durch Ihre echten Daten
    // Hier sollten Sie die Daten für den ausgewählten Monat und das Jahr zurückgeben
    return {
      0: 5.0,
      1: 25.0,
      2: 100.0,
      3: 75.0,
    };
  }

  Map<int, double> getExpensesData() {
    // Beispiel-Daten, ersetzen Sie dies durch Ihre echten Daten
    // Hier sollten Sie die Daten für den ausgewählten Monat und das Jahr zurückgeben
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
