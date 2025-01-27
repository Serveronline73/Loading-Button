class Payment {
  final double amount;
  final DateTime date;
  final String type;

  Payment({required this.amount, required this.date, required this.type});

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': DateTime.now(),
      'type': type,
    };
  }
}
