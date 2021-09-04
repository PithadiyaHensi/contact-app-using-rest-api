import 'package:contact_app/ContactDatabaseHelper.dart';
class ContactModel {
  int id;
  String fname;
  String lname;
  String email;
  String avatar;
  ContactModel(this.id, this.fname,this.lname, this.email, this.avatar);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'avatar': avatar,
    };
    return map;
  }

  ContactModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fname = map['fname'];
    lname = map['lname'];
    email = map['email'];
    avatar = map['avatar'];
  }
}