
import 'package:contact_app/ContactDatabaseHelper.dart';
import 'package:contact_app/Model/ContactModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ContactDetailActivity extends StatefulWidget {
  String id,firstName,lastName,email,avatar;
  ContactDetailActivity({Key key, this.id,this.firstName,this.lastName,this.email,this.avatar}) : super(key: key);

  @override
  ContactDetailActivityState createState() => ContactDetailActivityState();
}

class ContactDetailActivityState extends State<ContactDetailActivity> {
  final dio = new Dio();
  List<ContactModel> items = [];
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: Colors.cyan,
          body: Center(
            child: Container(margin: EdgeInsets.all(20.0),decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Colors.white),height: MediaQuery.of(context).size.height/2,child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Stack(
                children: [
                  Container(height: 120, decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg'),fit: BoxFit.fill))),
                  Align(alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/12.9),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(widget.avatar.toString()),
                          ),
                          SizedBox(height: 10.0,),
                          Text(widget.firstName.toString()+" "+widget.lastName.toString(),style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.0),
                          Text(widget.email.toString(),style: TextStyle(color: Colors.grey, fontSize: 15,)),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/35.4),
                            child: Column(
                              children: [
                                Divider(),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                                  Column(
                                    children: [
                                      Text("Followers",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text("1009",style: TextStyle(color: Colors.grey, fontSize: 12,)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Following",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text("500",style: TextStyle(color: Colors.grey, fontSize: 12,)),
                                    ],
                                  ),
                                ],),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.4),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.green,
                        backgroundColor: Colors.green,
                        minimumSize: Size(MediaQuery.of(context).size.width, 65),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                      ),
                      onPressed: () { _insert(widget.firstName, widget.lastName, widget.email, widget.avatar); },
                      child: Text(
                        "Follow",style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          )
    );
  }
  void _insert(firstName, lastName, email, avatar) async {
    // row to insert
    Map<String, dynamic> row = {DatabaseHelper.columnFirstName: firstName, DatabaseHelper.columnLastName: lastName, DatabaseHelper.columnEmail: email, DatabaseHelper.columnAvatar: avatar};
    ContactModel item = ContactModel.fromMap(row);
    final id = await dbHelper.insert(item);

    Map singlerow = await dbHelper.queryRowById(id);

    if (singlerow != null) {
      items.add(ContactModel.fromMap(row));
      setState(() {});
    }
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    items.clear();
    allRows.forEach((row) => items.add(ContactModel.fromMap(row)));
    setState(() {});
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
  }
}
