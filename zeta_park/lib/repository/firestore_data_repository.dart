import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/models/house.dart';
import 'package:flutter_application_1/models/payment.dart';

class FirestoreDataRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Expense>> getExpenses({required House house}) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('houses/${house.id}/expenses').get();

      // Extrahiere die Daten aus den Dokumenten
      List<Expense> expenses = querySnapshot.docs.map((doc) {
        return Expense.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return expenses;
    } catch (e) {
      print('Fehler beim Abrufen der Daten(expenses): $e');
      return [];
    }
  }

  // Ausgabe hinzufügen
  Future<void> addExpense(
      {required Expense expense, required House house}) async {
    try {
      await _firestore
          .collection('houses/${house.id}/expenses')
          .add(expense.toMap());
    } catch (e) {
      print('Fehler beim Hinzufügen der Ausgabe: $e');
    }
  }

  // Zahlungen abrufen
  Future<List<Payment>> getPayments({required House house}) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('houses/${house.id}/payments').get();

      // Extrahiere die Daten aus den Dokumenten
      List<Payment> payments = querySnapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return payments;
    } catch (e) {
      print('Fehler beim Abrufen der Daten: $e');
      return [];
    }
  }

// Zahlung hinzufügen
  Future<void> addPayment(
      {required Payment payment, required House house}) async {
    try {
      await _firestore
          .collection('houses/${house.id}/payments')
          .add(payment.toMap());
    } catch (e) {
      print('Fehler beim Hinzufügen der Zahlung: $e');
    }
  }
}
