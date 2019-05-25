import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_state_login.dart';

SharedPreferences sharedPreferences;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String data = '';
  String nameus = CurrentUser_state.NAME;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readcontent() async {
    getname();
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      this.data = contents;
      print('Data From Text File: ${data}');
      if (data != CurrentUser_state.QUOTE) {
        await file.writeAsString(CurrentUser_state.QUOTE);
        String contents = await file.readAsString();
        this.data = contents;
      }
      return this.data;
    } catch (e) {
      return 'Error';
    }
  }

  getname() async {
    sharedPreferences = await SharedPreferences.getInstance();
    this.nameus = await sharedPreferences.getString('nameuser');
    print(nameus);
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      readcontent();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello $nameus'),
              subtitle: Text(
                  'this is my quote "${CurrentUser_state.QUOTE != null ? CurrentUser_state.QUOTE == '' ? 'ยังไม่มีการระบุข้อมูล' : data != CurrentUser_state.QUOTE ? CurrentUser_state.QUOTE : data : 'ยังไม่มีการระบุข้อมูล'}"'),
            ),
            RaisedButton(
              color: Colors.red,
              child: Text(
                "PROFILE SETUP",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              color: Colors.white,
              child: Text(
                "MY FRIENDS",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed('/friend');
                Navigator.of(context).pushNamed('/allfriend');
              },
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                "SIGN OUT",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                test() async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('username', '');
                  sharedPreferences.setString('password', '');
                }

                test();
                CurrentUser_state.USERID = null;
                CurrentUser_state.NAME = null;
                CurrentUser_state.AGE = null;
                CurrentUser_state.PASSWORD = null;
                CurrentUser_state.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
