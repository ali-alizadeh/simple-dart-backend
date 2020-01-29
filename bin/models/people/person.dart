import 'package:meta/meta.dart';

class Person {
  final int id;
  final String name;
  final String phone;
  final DateTime birthday;
  final String nationalID;

  const Person({
    @required this.id,
    @required this.name,
    @required this.phone,
    @required this.birthday,
    @required this.nationalID,
  });

  Person.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phone = json['phone'],
        birthday = DateTime.parse(json['birthday']),
        nationalID = json['nationalID'];

  Person copyWith({
    int id,
    String name,
    String phone,
    DateTime birthday,
    String nationalID,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      nationalID: nationalID ?? this.nationalID,
    );
  }

  bool operator >(Person other) => id > other.id;

  bool operator <(Person other) => id < other.id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'birthday': birthday,
        'nationalID': nationalID,
      };
}
