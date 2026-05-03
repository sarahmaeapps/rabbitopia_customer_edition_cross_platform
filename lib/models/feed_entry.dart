class FeedEntry {
  final int? id;
  final String brand;
  final String supplier;
  final double weightLbs;
  final double price;
  final DateTime date;
  final double protein;
  final double fiber;
  final double fat;

  FeedEntry({
    this.id,
    required this.brand,
    required this.supplier,
    required this.weightLbs,
    required this.price,
    required this.date,
    required this.protein,
    required this.fiber,
    required this.fat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'supplier': supplier,
      'weightLbs': weightLbs,
      'price': price,
      'date': date.toIso8601String(),
      'protein': protein,
      'fiber': fiber,
      'fat': fat,
    };
  }

  factory FeedEntry.fromMap(Map<String, dynamic> map) {
    return FeedEntry(
      id: map['id'],
      brand: map['brand'] ?? '',
      supplier: map['supplier'] ?? '',
      weightLbs: (map['weightLbs'] ?? 0).toDouble(),
      price: (map['price'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
      protein: (map['protein'] ?? 0).toDouble(),
      fiber: (map['fiber'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
    );
  }
}
