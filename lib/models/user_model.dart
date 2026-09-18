class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String freeFireUid;
  final String teamName;
  final DateTime registeredAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.freeFireUid,
    required this.teamName,
    required this.registeredAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      freeFireUid: json['freeFireUid'] as String,
      teamName: json['teamName'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'freeFireUid': freeFireUid,
      'teamName': teamName,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }
}
