import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String id;
  final String itemName;
  final double amount;
  final DateTime date;
  final String invoiceDetails;

  Purchase({
    required this.id,
    required this.itemName,
    required this.amount,
    required this.date,
    required this.invoiceDetails,
  });

  factory Purchase.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Purchase(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      invoiceDetails: data['invoiceDetails'] ?? '',
    );
  }
}
