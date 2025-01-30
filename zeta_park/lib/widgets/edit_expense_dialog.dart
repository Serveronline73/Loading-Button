//Ausgabenliste bearbeiten und löschen von der Ausgabenliste

import 'package:flutter/material.dart';

class EditExpenseDialog {
  final BuildContext context;
  final TextEditingController descController;
  final TextEditingController amountController;
  final Future<void> Function(Map<String, dynamic>, double, String)
      updateExpense;
  final Map<String, dynamic> expense;
  final VoidCallback onUpdate;

  EditExpenseDialog({
    required this.context,
    required this.descController,
    required this.amountController,
    required this.updateExpense,
    required this.expense,
    required this.onUpdate,
  });

  void show() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                final double? newAmount =
                    double.tryParse(amountController.text);
                if (newAmount != null) {
                  await updateExpense(expense, newAmount, descController.text);
                  Navigator.pop(context);
                  onUpdate();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ausgabe wurde aktualisiert'),
                    ),
                  );
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
}
