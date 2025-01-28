import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String description;
  final double amount;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.date,
  });
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      description: map['description'],
      amount: map['amount'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'date': DateTime.now(),
    };
  }
}
