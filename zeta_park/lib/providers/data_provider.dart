import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/house.dart';
import 'package:flutter_application_1/models/payment.dart';
import 'package:flutter_application_1/repository/firestore_data_repository.dart';

class DataProvider extends ChangeNotifier {
  final FirestoreDataRepository repository;
  List<Expense> expenses = [];
  List<Payment> payments = [];
  House? house;

  DataProvider({required this.repository}) {
    fetchExpenses();
    fetchPayments();
  }

  House getHouse() {
    if (house == null) {
      return House(name: 'Zeta Park Blok 1/1', id: '11');
    }
    return house!;
  }

  List<Expense> getExpenses() {
    return expenses;
  }

  List<Payment> getPayments() {
    return payments;
  }

  void setHouse(House house) {
    this.house = house;
    notifyListeners();
  }

  fetchExpenses() async {
    try {
      expenses = await repository.getExpenses(house: getHouse());
      print('Expenses: $expenses');
    } catch (e) {
      print('Fehler beim Abrufen der Ausgaben: $e');
    }
    notifyListeners();
  }

  fetchPayments() async {
    try {
      payments = await repository.getPayments(house: getHouse());
    } catch (e) {
      print('Fehler beim Abrufen der Zahlungen: $e');
    }
    notifyListeners();
  }

  addExpense(Expense expense) async {
    try {
      await repository.addExpense(expense: expense, house: getHouse());
      //await fetchExpenses();
    } catch (e) {
      print('Fehler beim Hinzufügen der Ausgabe: $e');
    }
  }

  addPayment(Payment payment) async {
    try {
      await repository.addPayment(payment: payment, house: getHouse());
      //await fetchPayments();
    } catch (e) {
      print('Fehler beim Hinzufügen der Zahlung: $e');
    }
  }
}
