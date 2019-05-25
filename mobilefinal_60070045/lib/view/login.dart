import 'package:flutter/material.dart';
import 'package:mobilefinal_60070045/database/userDatabase.dart';

import 'package:toast/toast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../user_state_login.dart';

SharedPreferences sharedPreferences;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}
class LoginPageState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  User_data user = User_data();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isValid = false;
  int formState = 0;
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    checkstate_user(String user_in, String password_in) async {
      await user.open("user.db");
      Future<List<User_information>> allUser = user.getAllUser();
      Future isUserValid(String userid, String password) async {
        var userList_all_data = await allUser;
        for (var i = 0; i < userList_all_data.length; i++) {
          if (user_in == userList_all_data[i].userid &&
              password_in == userList_all_data[i].password) {
            CurrentUser_state.ID = userList_all_data[i].id;
            CurrentUser_state.USERID = userList_all_data[i].userid;
            CurrentUser_state.PASSWORD = userList_all_data[i].password;
            CurrentUser_state.NAME = userList_all_data[i].name;
            CurrentUser_state.AGE = userList_all_data[i].age;
            CurrentUser_state.QUOTE = userList_all_data[i].quote;
            this.isValid = true;
            sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("username", userList_all_data[i].userid);
            sharedPreferences.setString("password", userList_all_data[i].password);
            break;
          }
        }
      }
      isUserValid(user_in, password_in);
      print(this.isValid);
      if (this.isValid == true) {
        return Navigator.pushReplacementNamed(context, '/home');
      }
    }
    checkUser_login() async {
      sharedPreferences = await SharedPreferences.getInstance();
      String user_state = sharedPreferences.getString('username');
      String password_state = sharedPreferences.getString('password');
      if (user_state != "" && user_state != null) {
        checkstate_user(user_state, password_state);
      }
    }

    checkUser_login();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      chk2(String userchk, String passwordchk) async {
        await user.open("user.db");
        Future<List<User_information>> allUser = user.getAllUser();
        Future isUserValid(String userid, String password) async {
          var userList = await allUser;
          for (var i = 0; i < userList.length; i++) {
            print('${userid} == ${userList[i].userid} ${password} == ${userList[i].password}');
            if (userid == userList[i].userid &&
                password == userList[i].password) {
              CurrentUser_state.ID = userList[i].id;
              CurrentUser_state.USERID = userList[i].userid;
              CurrentUser_state.NAME = userList[i].name;
              CurrentUser_state.AGE = userList[i].age;
              CurrentUser_state.PASSWORD = userList[i].password;
              CurrentUser_state.QUOTE = userList[i].quote;
              this.isValid = true;
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("username", userList[i].userid);
              sharedPreferences.setString("password", userList[i].password);
              return Navigator.pushReplacementNamed(context, '/home');
              break;
            }
          }
        }
        isUserValid(userchk, passwordchk);
      }

      getCredential() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String userchk = sharedPreferences.getString('username');
        String passwordchk = sharedPreferences.getString('password');
        if (userchk != "" && userchk != null) {
          chk2(userchk, passwordchk);
        }
        print(userchk);
      }

      getCredential();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              // child: Image.asset(
              //   "assets/banner.jpg",
              //   width: 200,
              //   height: 200,
                
              // ),
              child: Image.network('https://pbs.twimg.com/profile_images/1111648583462191104/JnfJPVuq_400x400.jpg',width:200,height:200),
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "UserId",
                  icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User_information>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      CurrentUser_state.ID = userList[i].id;
                      CurrentUser_state.USERID = userList[i].userid;
                      CurrentUser_state.NAME = userList[i].name;
                      CurrentUser_state.AGE = userList[i].age;
                      CurrentUser_state.PASSWORD = userList[i].password;
                      CurrentUser_state.QUOTE = userList[i].quote;
                      this.isValid = true;
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "username", userList[i].userid);
                      sharedPreferences.setString(
                          "password", userList[i].password);
                      break;
                    }
                  }
                }

                if (this.formState != 2) {
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;
                } else {
                  this.formState = 0;
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/mainpage');
                    userid.text = "";
                    password.text = "";
                  }
                }

                Future showAllUser() async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {}
                }

                showAllUser();
              },
            ),
            FlatButton(
              child: Container(
                child: Text("register new user", textAlign: TextAlign.right),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 180.0),
            ),
          ],
        ),
      ),
    );
  }
}
