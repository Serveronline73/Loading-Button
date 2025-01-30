// Eingabefelder Einzahlung NK und Nachzahlung NK

import 'package:flutter/material.dart';

class PaymentFieldsNK extends StatelessWidget {
  final TextEditingController betrag1Controller;
  final TextEditingController betrag2Controller;
  final Function(String) updateBetrag1;
  final Function(String) updateBetrag2;

  const PaymentFieldsNK({
    super.key,
    required this.betrag1Controller,
    required this.betrag2Controller,
    required this.updateBetrag1,
    required this.updateBetrag2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: betrag1Controller,
            decoration: InputDecoration(
              labelText: "Einzahlung NK",
              labelStyle: const TextStyle(
                color: Color(0xFF488AEC),
              ),
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: updateBetrag1,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: betrag2Controller,
            decoration: InputDecoration(
              labelText: "Nachzuhlung NK",
              labelStyle: const TextStyle(
                color: Color(0xFF488AEC),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: updateBetrag2,
          ),
        ),
      ],
    );
  }
}
