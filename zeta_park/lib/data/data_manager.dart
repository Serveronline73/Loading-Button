import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  Map<String, Map<String, Map<int, Map<String, double>>>> blockAmounts = {};
  List<Map<String, dynamic>> expenses = [];

  Future<void> loadData() async {
    await loadExpenses();
    await loadPayments();
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString('expenses');
    if (expensesJson != null) {
      expenses = List<Map<String, dynamic>>.from(
          jsonDecode(expensesJson).map((x) => Map<String, dynamic>.from(x)));
    }
  }

  Future<void> loadPayments() async {
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
  }

  Future<void> saveExpense(double amount, String description, String date,
      String month, int year) async {
    expenses.add({
      'amount': amount,
      'description': description,
      'date': date,
      'month': month,
      'year': year,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expenses', jsonEncode(expenses));
  }

  List<Map<String, dynamic>> getExpenses(String month, int year) {
    return expenses
        .where(
            (expense) => expense['month'] == month && expense['year'] == year)
        .toList();
  }

  Future<void> savePayment(
      String block, String month, int year, double aidat, double ek) async {
    if (!blockAmounts.containsKey(block)) {
      blockAmounts[block] = {};
    }
    if (!blockAmounts[block]!.containsKey(month)) {
      blockAmounts[block]![month] = {};
    }
    blockAmounts[block]![month]![year] = {
      'aidat': aidat,
      'ek': ek,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('payments', jsonEncode(blockAmounts));
  }

  Map<String, Map<String, Map<int, Map<String, double>>>> getBlockAmounts() {
    return blockAmounts;
  }
}
