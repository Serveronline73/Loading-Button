import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Speichern von Ausgaben
  Future<void> saveExpense(double amount, String description, String date,
      String month, int year) async {
    try {
      await _firestore.collection('expenses').add({
        'amount': amount,
        'description': description,
        'date': date,
        'month': month,
        'year': year,
      });
    } catch (e) {
      print('Error saving expense to Firebase: $e');
    }
  }

  // Laden von Ausgaben
  Future<List<Map<String, dynamic>>> loadExpenses() async {
    try {
      final snapshot = await _firestore.collection('expenses').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading expenses from Firebase: $e');
      return [];
    }
  }

  // Speichern von Zahlungen
  Future<void> savePayment(
      String block, String month, int year, double aidat, double ek) async {
    try {
      await _firestore.collection('payments').add({
        'block': block,
        'month': month,
        'year': year,
        'aidat': aidat,
        'ek': ek,
      });
    } catch (e) {
      print('Error saving payment to Firebase: $e');
    }
  }

  // Laden von Zahlungen
  Future<List<Map<String, dynamic>>> loadPayments() async {
    try {
      final snapshot = await _firestore.collection('payments').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading payments from Firebase: $e');
      return [];
    }
  }

  // Delete-Funktion
  Future<void> deleteExpense(Map<String, dynamic> expense) async {
    try {
      String expenseId =
          expense['id']; // Annahme: Jede Ausgabe hat eine eindeutige ID

      await _firestore.collection('expenses').doc(expenseId).delete();
      print('Expense deleted from Firebase');
    } catch (e) {
      print('Error deleting expense from Firestore: $e');
      rethrow; // Fehler weitergeben, falls erforderlich
    }
  }

  // updated die ausgben in Firebase
  Future<void> updateExpense(Map<String, dynamic> expense, double newAmount,
      String newDescription) async {
    try {
      String expenseId = expense['id']; // Annahme: Jede Ausgabe hat eine ID

      await _firestore.collection('expenses').doc(expenseId).update({
        'amount': newAmount,
        'description': newDescription,
      });

      print('Expense updated in Firebase');
    } catch (e) {
      print('Error updating expense in Firestore: $e');
      rethrow; // Fehler weitergeben
    }
  }
}
