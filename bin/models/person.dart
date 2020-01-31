import 'package:meta/meta.dart';

class Person {
  final String name;
  final String phone;
  final DateTime birthday;
  final int nationalID;

  const Person({
    @required this.name,
    @required this.phone,
    @required this.birthday,
    @required this.nationalID,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        birthday = DateTime.parse(json['birthday']),
        nationalID = json['nationalID'];

  factory Person.fromNantionalId(int id) {
    return Person(
      name: null,
      phone: null,
      birthday: null,
      nationalID: id,
    );
  }

  Person copyWith({
    String name,
    String phone,
    DateTime birthday,
    String nationalID,
  }) {
    return Person(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      nationalID: nationalID ?? this.nationalID,
    );
  }

  bool operator >(Person other) => nationalID > other.nationalID;

  bool operator <(Person other) => nationalID < other.nationalID;

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'birthday': birthday.toIso8601String(),
        'nationalID': nationalID,
      };
}
