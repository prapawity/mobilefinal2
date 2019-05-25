import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilefinal_60070045/database/userDatabase.dart';
import 'package:path_provider/path_provider.dart';

import '../user_state_login.dart';


class Profile_User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Profile_User_State();
  }
}

class Profile_User_State extends State<Profile_User> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await _localFile;
    await file.writeAsString('${data}');
  }

  final _formkey = GlobalKey<FormState>();

  User_data user = User_data();
  final userid = TextEditingController(text: CurrentUser_state.USERID);
  final name = TextEditingController(text: CurrentUser_state.NAME);
  final age = TextEditingController(text: CurrentUser_state.AGE);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentUser_state.QUOTE);

  bool isUserIn = false;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Setup"),
          centerTitle: true,
        ),
        body: Form(
          key: _formkey,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "User Id",
                      hintText: "User Id must be between 6 to 12",
                      icon:
                          Icon(Icons.account_box, size: 40, color: Colors.grey),
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (isUserIn) {
                        return "This Username is taken";
                      } else if (value.length < 6 || value.length > 12) {
                        return "Please fill UserId Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "ex. 'John Snow'",
                      icon: Icon(Icons.account_circle,
                          size: 40, color: Colors.grey),
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (countSpace(value) != 1) {
                        return "Please fill Name Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Please fill Age Between 10 to 80",
                      icon:
                          Icon(Icons.event_note, size: 40, color: Colors.grey),
                    ),
                    controller: age,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill Age";
                      } else if (!isNumeric(value) ||
                          int.parse(value) < 10 ||
                          int.parse(value) > 80) {
                        return "Please fill Age correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password must be longer than 6",
                      icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                    ),
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 6) {
                        return "Please fill Password Correctly";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quote",
                      hintText: "Explain you self!",
                      icon: Icon(Icons.settings_system_daydream,
                          size: 40, color: Colors.grey),
                    ),
                    controller: quote,
                    keyboardType: TextInputType.text,
                    maxLines: 5),
                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                RaisedButton(
                    child: Text("SAVE"),
                    onPressed: () async {
                      await user.open("user.db");
                      Future<List<User_information>> allUser = user.getAllUser();
                      User_information userData = User_information();
                      userData.id = CurrentUser_state.ID;
                      userData.userid = userid.text;
                      userData.name = name.text;
                      userData.age = age.text;
                      userData.password = password.text;
                      userData.quote = quote.text;
                      writeContent(quote.text);
                      //function to check if user in
                      Future isUserTaken(User_information user) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (user.userid == userList[i].userid &&
                              CurrentUser_state.ID != userList[i].id) {
                            this.isUserIn = true;
                            break;
                          }
                        }
                      }

                      //validate form
                      if (_formkey.currentState.validate()) {
                        await isUserTaken(userData);
                        //if user not exist
                        if (!this.isUserIn) {
                          await user.updateUser(userData);
                          CurrentUser_state.USERID = userData.userid;
                          CurrentUser_state.NAME = userData.name;
                          CurrentUser_state.AGE = userData.age;
                          CurrentUser_state.PASSWORD = userData.password;
                          CurrentUser_state.QUOTE = userData.quote;
                          Navigator.pop(context);
                          print('insert complete');
                        }
                      }

                      this.isUserIn = false;
                    }),
              ]),
        ));
  }
}
