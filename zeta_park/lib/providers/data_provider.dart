import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/payment.dart';

class DataProvider extends ChangeNotifier {
  final List<Expense> expenses = [];
  List<Payment> payments = [];

  List<Expense> getExpenses() {
    return expenses;
  }

  List<Payment> getPayments() {
    return payments;
  }
}
