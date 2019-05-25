import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mobilefinal_60070045/view/todopage.dart';

class List_Friend_Current_User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return List_friend_state();
  }
}

Future<List<User_data>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');
  List<User_data> userApi_data = [];
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var user = User_data.fromJson(body[i]);
      userApi_data.add(user);
    }
    return userApi_data;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class User_data {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User_data({this.id, this.name, this.email, this.phone, this.website});

  factory User_data.fromJson(Map<String, dynamic> json) {
    return User_data(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class List_friend_state extends State<List_Friend_Current_User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My All Friends"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.white,
              child: Text("BACK",style: TextStyle(color: Color(0xFF4e69a2)),),
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),
            FutureBuilder(
              future: fetchUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[CircularProgressIndicator()],
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<User_data> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            color: Color(0xffF7EE7F),
            child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${(values[index].id).toString()} : ${values[index].name}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 10)),
                    Text(
                      values[index].email,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      values[index].phone,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      values[index].website,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoPage(id: values[index].id),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
