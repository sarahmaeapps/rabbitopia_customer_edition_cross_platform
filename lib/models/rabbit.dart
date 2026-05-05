import 'package:cloud_firestore/cloud_firestore.dart';

class Rabbit {
  final String id;
  final String name;
  final String earTattoo;
  final String breed;
  final DateTime? birthDate;
  final String pictureUrl;
  final double price;
  final String hutchId;
  final String generation;
  final String status;
  final String notes;
  final Map<String, dynamic> pedigree; // Recursive 3-generation parent mapping
  final String? grade;
  final double? sopScore;
  final bool forSale;

   Rabbit({
    required this.id,
    required this.name,
    required this.earTattoo,
    required this.breed,
    this.birthDate,
    required this.pictureUrl,
    required this.price,
    required this.hutchId,
    required this.generation,
    required this.status,
    required this.notes,
    required this.pedigree,
    this.grade,
    this.sopScore,
    this.forSale = false,
  });

  factory Rabbit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is Timestamp) return date.toDate();
      if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return Rabbit(
      id: doc.id,
      name: data['name'] ?? '',
      earTattoo: data['earTattoo'] ?? data['eartattoo'] ?? '',
      breed: data['breed'] ?? '',
      birthDate: parseDate(data['birthDate'] ?? data['dateOfBirth']),
      pictureUrl: data['imagePath'] ?? data['pictureUrl'] ?? '',
      price: (data['salePrice'] ?? data['price'] ?? 0).toDouble(),
      hutchId: data['hutchId'] ?? '',
      generation: (data['genCount'] ?? data['generation'] ?? 0).toString(),
      status: data['status'] ?? '',
      notes: data['notes'] ?? '',
      pedigree: data['pedigree'] ?? {},
      grade: data['grade'],
      sopScore: (data['sopScore'] ?? 0).toDouble(),
      forSale: data['forSale'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'earTattoo': earTattoo,
      'breed': breed,
      'birthDate': birthDate,
      'pictureUrl': pictureUrl,
      'price': price,
      'hutchId': hutchId,
      'generation': generation,
      'status': status,
      'notes': notes,
      'pedigree': pedigree,
      'grade': grade,
      'sopScore': sopScore,
      'forSale': forSale,
    };
  }
}
