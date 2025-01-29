import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

import '../models/payment.dart';
import '../providers/data_provider.dart';
import '../providers/role.dart';

class PaymentCard extends StatelessWidget {
  final TextEditingController betrag1Controller;
  final TextEditingController betrag2Controller;
  final String selectedMonth;
  final int selectedYear;
  final double betrag1;
  final double betrag2;
  final Currency selectedCurrency;
  final double monthlyTotal;

  const PaymentCard({
    super.key,
    required this.betrag1Controller,
    required this.betrag2Controller,
    required this.selectedMonth,
    required this.selectedYear,
    required this.betrag1,
    required this.betrag2,
    required this.selectedCurrency,
    required this.monthlyTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF070F2D), Color(0xFF3A3C54)],
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
        children: [
          if (context.watch<RoleManager>().admin) ...[
            _buildPaymentFields(context),
            const SizedBox(height: 16.0),
          ],
          const Text(
            "Verwaltung: Dennis Durmus",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          Divider(thickness: 1, color: Colors.grey[300]),
          const SizedBox(height: 8.0),
          const Text(
            "Einzahlung Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildPaymentDetails(context),
        ],
      ),
    );
  }

  Widget _buildPaymentFields(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: betrag1Controller,
                decoration: InputDecoration(
                  labelText: "Einzahlung NK",
                  labelStyle: const TextStyle(color: Color(0xFF488AEC)),
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: betrag2Controller,
                decoration: InputDecoration(
                  labelText: "Nachzahlung NK",
                  labelStyle: const TextStyle(color: Color(0xFF488AEC)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => _handlePaymentSubmission(context),
          child: const Text('Bestätigen'),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nebenkosten Zahlungen:",
              style: TextStyle(color: Color(0xFF488AEC)),
            ),
            Text(
              '${Money.fromInt((context.watch<DataProvider>().depositExpensesSum * 100).toInt(), code: selectedCurrency.code)}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nebenkosten Nachzahlung:",
              style: TextStyle(color: Color(0xFF488AEC)),
            ),
            Text(
                '${Money.fromInt((context.watch<DataProvider>().additionalExpensesSum * 100).toInt(), code: selectedCurrency.code)}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Gesamtbetrag ($selectedMonth $selectedYear):",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF488AEC),
              ),
            ),
            Text(
              '${Money.fromInt((context.watch<DataProvider>().totalExpensesSum * 100).toInt(), code: selectedCurrency.code)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handlePaymentSubmission(BuildContext context) {
    if (betrag1Controller.text.isNotEmpty) {
      context.read<DataProvider>().addPayment(
            Payment(
              amount: double.parse(betrag1Controller.text),
              date: DateTime.now(),
              type: "deposit",
            ),
          );
      betrag1Controller.clear();
    }
    if (betrag2Controller.text.isNotEmpty) {
      context.read<DataProvider>().addPayment(
            Payment(
              amount: double.parse(betrag2Controller.text),
              date: DateTime.now(),
              type: "additional",
            ),
          );
      betrag2Controller.clear();
    }
  }
}
