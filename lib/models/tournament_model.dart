class Tournament {
  final String id;
  final String name;
  final String description;
  final double prizePool;
  final int participants;
  final int maxParticipants;
  final DateTime startDate;
  final String status;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.prizePool,
    required this.participants,
    required this.maxParticipants,
    required this.startDate,
    required this.status,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      prizePool: (json['prizePool'] as num).toDouble(),
      participants: json['participants'] as int,
      maxParticipants: json['maxParticipants'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'prizePool': prizePool,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'startDate': startDate.toIso8601String(),
      'status': status,
    };
  }
}
