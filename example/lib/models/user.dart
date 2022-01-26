import 'dart:convert';

class User {
  String id;
  String name;
  DateTime birthdate;
  User({
    required this.id,
    required this.name,
    required this.birthdate,
  });

  User copyWith({
    String? id,
    String? name,
    DateTime? birthdate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthdate': birthdate.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      birthdate: DateTime.fromMillisecondsSinceEpoch(map['birthdate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, name: $name, birthdate: $birthdate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.birthdate == birthdate;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ birthdate.hashCode;

  static List<User> get generateRandomUser => <User>[
        User(
          id: '1234-5678-9012-3456',
          name: 'Max',
          birthdate: DateTime.now(),
        ),
        User(
          id: '5678-9012-3456-1234',
          name: 'Marie',
          birthdate: DateTime.now(),
        ),
        User(
          id: '3456-1234-5678-9012',
          name: 'Maya',
          birthdate: DateTime.now(),
        ),
        
      ];
}
