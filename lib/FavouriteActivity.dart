import 'package:contact_app/ContactDatabaseHelper.dart';
import 'package:contact_app/ContactDetailActivity.dart';
import 'package:contact_app/Model/ContactModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class FavouriteActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FavouriteActivityState();
}

class FavouriteActivityState extends State<FavouriteActivity> {
  DBHelper dbHelper;
  Future<List<ContactModel>> contact;
  List<ContactModel> contactList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    dbHelper = DBHelper();
    refresheContactList();
    super.initState();
  }

  refresheContactList() {
    setState(() {
      dbHelper.getEmployee().then((value) {
        print(value.length);
        contactList.addAll(value);
        setState(() {});
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,backgroundColor: Colors.cyan,
      appBar: AppBar(backgroundColor: Colors.cyan,shadowColor: Colors.transparent,
        title: const Text("Favourite", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget buildList() {
    return FutureBuilder(
        future: dbHelper.getEmployee(),
        builder: (context, snapshot) {
        return ListView.builder(
          itemCount: contactList.length,
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0
                  ),
                  child: ListTile(tileColor: Colors.white,
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                          contactList[index].avatar,
                        ),
                      ),
                      trailing: GestureDetector(
                          onTap:(){setState(() {
                            dbHelper.delete(contactList[index].id);
                            contactList.removeAt(index);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Delete Successfully..!!')));
                            //refresheContactList();
                          });},child: Icon(Icons.delete, color: Colors.black)),
                      title: Text((contactList[index].fname)+" "+(contactList[index].lname)),
                      subtitle: Text((contactList[index].email)),
                      onTap:(){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ContactDetailActivity(id: contactList[index].id.toString(),avatar: contactList[index].avatar, firstName: contactList[index].fname,lastName: contactList[index].lname,email: contactList[index].email, from: "local")));
                      }
                  ),
                ),
              );
          },
        );
      }
    );
  }

}
