import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/repository/sharedPreferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class ExpensesCard extends StatelessWidget {
  final DataManager dataManager;
  final String selectedMonth;
  final int selectedYear;
  final Currency selectedCurrency;
  final TextEditingController ausgabeController;
  final TextEditingController ausgabeDescriptionController;
  final double ausgabe;
  final String ausgabeDescription;
  final ValueChanged<double> onAusgabeChanged;
  final ValueChanged<String> onAusgabeDescriptionChanged;
  final VoidCallback onSaveExpense;
  final Function(Map<String, dynamic>) onShowEditDialog;
  final Function(Map<String, dynamic>) onShowDeleteConfirmation;

  const ExpensesCard({
    super.key,
    required this.dataManager,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedCurrency,
    required this.ausgabeController,
    required this.ausgabeDescriptionController,
    required this.ausgabe,
    required this.ausgabeDescription,
    required this.onAusgabeChanged,
    required this.onAusgabeDescriptionChanged,
    required this.onSaveExpense,
    required this.onShowEditDialog,
    required this.onShowDeleteConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    final expenses = dataManager.getExpenses(selectedMonth, selectedYear);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A3C54), Color(0xFF070F2D)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF545A6A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF488AEC).withAlpha((0.19 * 255).toInt()),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ausgabenliste',
            style: TextStyle(
              color: Color(0xFF488AEC),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ausgaben für $selectedMonth $selectedYear',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          context.watch<RoleManager>().admin
              ? Column(
                  children: [
                    TextField(
                      controller: ausgabeController,
                      decoration: InputDecoration(
                        labelText: 'Ausgabenbetrag',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        onAusgabeChanged(double.tryParse(value) ?? 0.00);
                        SharedPreferencesRepository.saveBetrag(
                            'ausgabe', ausgabe);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: ausgabeDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Beschreibung',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        onAusgabeDescriptionChanged(value);
                        SharedPreferencesRepository.saveNebenkosten(
                            'ausgabeDescription', ausgabeDescription);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: onSaveExpense,
                      child: const Text('Ausgabe speichern'),
                    ),
                  ],
                )
              : const SizedBox(),
          if (expenses.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            const Divider(
              thickness: 1,
              color: Color(0xFF488AEC),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Ausgabenliste',
              style: TextStyle(
                color: Color(0xFF488AEC),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: expenses.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return const Divider(
                    color: Color(0xFF488AEC),
                    thickness: 1,
                    height: 1,
                  );
                }
                final Map<String, dynamic> expense = expenses[index ~/ 2];
                return Slidable(
                  endActionPane: context.watch<RoleManager>().admin
                      ? ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                onShowEditDialog(expense);
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Bearbeiten',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                onShowDeleteConfirmation(expense);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Löschen',
                            ),
                          ],
                        )
                      : null,
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      expense['description'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(expense['date'],
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(
                      '${Money.fromInt((expense['amount'] * 100).toInt(), code: selectedCurrency.code)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            const Divider(
              thickness: 1,
              color: Color(0xFF488AEC),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Gesamtausgaben für $selectedMonth $selectedYear:',
                    style: const TextStyle(
                      color: Color(0xFF488AEC),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${Money.fromInt((expenses.fold<double>(0, (sum, expense) => sum + expense['amount']) * 100).toInt(), code: selectedCurrency.code)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
