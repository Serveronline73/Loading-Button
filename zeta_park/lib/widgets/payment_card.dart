import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class PaymentCard extends StatelessWidget {
  final TextEditingController betrag1Controller;
  final TextEditingController betrag2Controller;
  final double betrag1;
  final double betrag2;
  final double gesamtbetrag;
  final Currency selectedCurrency;
  final VoidCallback onConfirmPressed;
  final ValueChanged<String> onBetrag1Changed;
  final ValueChanged<String> onBetrag2Changed;

  const PaymentCard({
    super.key,
    required this.betrag1Controller,
    required this.betrag2Controller,
    required this.betrag1,
    required this.betrag2,
    required this.gesamtbetrag,
    required this.selectedCurrency,
    required this.onConfirmPressed,
    required this.onBetrag1Changed,
    required this.onBetrag2Changed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentFields(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onConfirmPressed,
              child: const Text('Bestätigen'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Site Yönetimi: Fatih Sevindik',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Divider(thickness: 1, color: Colors.grey[300]),
            const SizedBox(height: 8.0),
            const Text(
              'Banka Dekont Giris Bilgileri',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            const Text('Visa\n**** **** **** 4243'),
            Divider(thickness: 1, color: Colors.grey[300]),
            const SizedBox(height: 8.0),
            _buildPaymentSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: betrag1Controller,
            decoration: InputDecoration(
              labelText: 'Aidat Ödemesi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: onBetrag1Changed,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: betrag2Controller,
            decoration: InputDecoration(
              labelText: 'Ek Ödemesi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: onBetrag2Changed,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aidat Ödemesi:'),
            Text(
                '${Money.fromInt((betrag1 * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ek Ödeme:'),
            Text(
                '${Money.fromInt((betrag2 * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Toplam Ödeme:'),
            Text(
                '${Money.fromInt((gesamtbetrag * 100).toInt(), code: selectedCurrency.code)}'),
          ],
        ),
      ],
    );
  }
}
