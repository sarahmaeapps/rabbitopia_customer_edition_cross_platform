class Housing {
  final int? id;
  final String hutchId;
  final String residents;
  final String predatorSigns;
  final String upgrades;
  final String repairHistory;

  Housing({
    this.id,
    required this.hutchId,
    required this.residents,
    required this.predatorSigns,
    required this.upgrades,
    required this.repairHistory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hutchId': hutchId,
      'residents': residents,
      'predatorSigns': predatorSigns,
      'upgrades': upgrades,
      'repairHistory': repairHistory,
    };
  }

  factory Housing.fromMap(Map<String, dynamic> map) {
    return Housing(
      id: map['id'],
      hutchId: map['hutchId'] ?? '',
      residents: map['residents'] ?? '',
      predatorSigns: map['predatorSigns'] ?? '',
      upgrades: map['upgrades'] ?? '',
      repairHistory: map['repairHistory'] ?? '',
    );
  }
}
