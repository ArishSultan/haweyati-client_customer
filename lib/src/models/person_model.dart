import 'package:hive/hive.dart';
// part 'person_model.g.dart';

@HiveType(typeId: 12)
class Person extends HiveObject{
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String type;
  @HiveField(3) String email;
  @HiveField(4) String contact;
  @HiveField(5) String username;
  @HiveField(6) String password;

  Person({
    this.id,
    this.name,
    this.type,
    this.email,
    this.contact,
    this.username,
    this.password
  });

  Person.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    type = json['type'];
    email = json['email'];
    contact = json['contact'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'type': type,
    'email': email,
    'contact': contact,
    'username': username,
    'password': password
  };
}