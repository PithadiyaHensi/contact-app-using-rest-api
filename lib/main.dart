import 'package:contact_app/ContactDetailActivity.dart';
import 'package:contact_app/FavouriteActivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State<Home> {
  static int page = 0;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;
  List users = new List();
  final dio = new Dio();
  List<String> searchList = [
    "A-z",
    "z-A",
  ];
  String dropDownValue = "A-z";
  @override
  void initState() {
    this.getMoreDataAd(page);
    this.getMoreDataDc(page);
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if(dropDownValue=="A-z"){
          getMoreDataAd(page);}
        else{
          getMoreDataDc(page);}
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.cyan,
      appBar: AppBar(backgroundColor: Colors.cyan,shadowColor: Colors.transparent,
        title: const Text("Contact App", style: TextStyle(color: Colors.white)),actions: [Container(width: 50,
          child: DropdownButton<String>(
            underline: Container(color: Colors.transparent, height: 2.0),
            dropdownColor: Colors.white,
            hint: Text("Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                )),
            value: dropDownValue,
            iconSize: 24,
            elevation: 16,
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            isExpanded: true,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropDownValue = newValue;
                if(dropDownValue=="A-z"){
                  users.clear();
                  page = 0;
                  getMoreDataAd(page);}
                else{
                  users.clear();
                  page = 0;
                  getMoreDataDc(page);}
              });
            },
            items: searchList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                ),
              );
            }).toList(),
          ),
        ),IconButton(icon: Icon(Icons.favorite, color: Colors.white), onPressed:(){Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FavouriteActivity()));}),
          ],
      ),
      body: Container(
        child: buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: users.length + 1,
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return buildProgressIndicator();
        } else {
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
                    users[index]['avatar'],
                  ),
                ),
                title: Text((users[index]['first_name'])+" "+(users[index]['last_name'])),
                subtitle: Text((users[index]['email'])),
                onTap:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactDetailActivity(id: (users[index]['id'].toString()),avatar: users[index]['avatar'], firstName: users[index]['first_name'],lastName: users[index]['last_name'],email: users[index]['email'])));
                }
              ),
            ),
          );
        }
      },
      controller: scrollController,
    );
  }
  void getMoreDataAd(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = "https://reqres.in/api/users?page="+ index.toString();
      print(url);
      final response = await dio.get(url);
      List tList = new List();
      for (int i = 0; i < response.data['data'].length; i++) {
        tList.add(response.data['data'][i]);
      }

      setState(() {
        isLoading = false;
        users.addAll(tList);
        page++;
      });
    }
  }
  void getMoreDataDc(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = "https://reqres.in/api/users?page="+ index.toString();
      print(url);
      final response = await dio.get(url);
      List tList = new List();
      for (int i = 0; i < response.data['data'].length; i++) {
        tList.add(response.data['data'][i]);
      }

      setState(() {
        isLoading = false;
        users.addAll(tList.reversed);
        page++;
      });
    }
  }

  Widget buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(backgroundColor: Colors.white,),
        ),
      ),
    );
  }

}
