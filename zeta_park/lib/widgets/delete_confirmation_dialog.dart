// Ausgabenliste Sliteable Widget Löschen oder Bearbeiten Alert Dialog

import 'package:flutter/material.dart';

class DeleteConfirmationDialog {
  final BuildContext context;
  final Future<void> Function(Map<String, dynamic>) deleteExpense;
  final VoidCallback onDelete;

  DeleteConfirmationDialog({
    required this.context,
    required this.deleteExpense,
    required this.onDelete,
  });

  void show(Map<String, dynamic> expense) {
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
                deleteExpense(expense); // Ausgabe in der Datenbank löschen
                Navigator.pop(context); // Dialog schließen
                onDelete();
                ScaffoldMessenger.of(context).showSnackBar(
                  // SnackBar anzeigen
                  const SnackBar(
                    // SnackBar mit Nachricht anzeigen
                    content: Text('Ausgabe wurde gelöscht'),
                  ),
                );
              },
              child: const Text('Löschen', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
