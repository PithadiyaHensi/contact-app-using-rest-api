import 'package:contact_app/ContactDatabaseHelper.dart';

class ContactModel {
  int id;
  int categoryId;
  String first_name;
  String last_name;
  String email;
  String avatar;
  bool isexpand = false;
  ContactModel({
    this.id,
    this.categoryId,
    this.first_name,
    this.last_name,
    this.email,
    this.avatar,
  });
  factory ContactModel.fromJson(Map<String, dynamic> json) => new ContactModel(
      id: json["id"],
      first_name: json["first_name"],
      last_name: json["last_name"],
      email: json["email"],
      avatar: json["avatar"],
  );

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnFirstName: first_name,
      DatabaseHelper.columnLastName: last_name,
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnAvatar: avatar,
    };
  }
  ContactModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    first_name = map['first_name'];
    last_name = map['last_name'];
    email = map['email'];
    avatar = map['avatar'];
    isexpand = false;
  }
}