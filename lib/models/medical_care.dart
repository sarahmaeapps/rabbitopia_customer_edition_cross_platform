class MedicalCare {
  final int? id;
  final String rabbitId;
  final DateTime date;
  final String description;
  final double cost;
  final String medications;
  final String vetNotes;

  MedicalCare({
    this.id,
    required this.rabbitId,
    required this.date,
    required this.description,
    required this.cost,
    required this.medications,
    required this.vetNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rabbitId': rabbitId,
      'date': date.toIso8601String(),
      'description': description,
      'cost': cost,
      'medications': medications,
      'vetNotes': vetNotes,
    };
  }

  factory MedicalCare.fromMap(Map<String, dynamic> map) {
    return MedicalCare(
      id: map['id'],
      rabbitId: map['rabbitId'] ?? '',
      date: DateTime.parse(map['date']),
      description: map['description'] ?? '',
      cost: (map['cost'] ?? 0).toDouble(),
      medications: map['medications'] ?? '',
      vetNotes: map['vetNotes'] ?? '',
    );
  }
}
