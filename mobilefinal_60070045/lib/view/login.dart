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
  int form_status = 0;
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Check_from_all_User(String user_in, String password_in) async {
        await user.open("user.db");
        Future<List<User_information>> allUser = user.getAllUser();
        Future isUserValid(String userid, String password) async {
          var userList = await allUser;
          for (var i = 0; i < userList.length; i++) {
            if (userid == userList[i].userid &&
                password == userList[i].password) {
              this.isValid = true;
              CurrentUser_state.ID = userList[i].id;
              CurrentUser_state.USERID = userList[i].userid;
              CurrentUser_state.NAME = userList[i].name;
              CurrentUser_state.AGE = userList[i].age;
              CurrentUser_state.PASSWORD = userList[i].password;
              CurrentUser_state.QUOTE = userList[i].quote;
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("username", userList[i].userid);
              sharedPreferences.setString("password", userList[i].password);
              return Navigator.pushReplacementNamed(context, '/mainpage');
            }
          }
        }

        isUserValid(user_in, password_in);
      }

      Check_State_User() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String user_now = sharedPreferences.getString('username');
        String password_now = sharedPreferences.getString('password');
        if (user_now != "" && user_now != null) {
          Check_from_all_User(user_now, password_now);
        }
      }

      Check_State_User();
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
              child: Image.network(
                  'https://www.coplus.co.uk/wp-content/uploads/2017/09/Website-key-icon-green.png',
                  width: 200,
                  height: 200),
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.form_status += 1;
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
                    this.form_status += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              color: Color(0xFF4e69a2),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User_information>> allUser = user.getAllUser();
                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      this.isValid = true;
                      CurrentUser_state.ID = userList[i].id;
                      CurrentUser_state.USERID = userList[i].userid;
                      CurrentUser_state.NAME = userList[i].name;
                      CurrentUser_state.AGE = userList[i].age;
                      CurrentUser_state.PASSWORD = userList[i].password;
                      CurrentUser_state.QUOTE = userList[i].quote;
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "username", userList[i].userid);
                      sharedPreferences.setString(
                          "password", userList[i].password);
                      break;
                    }
                  }
                }
                if (this.form_status != 2) {
                  this.form_status = 0;
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.BOTTOM,
                      backgroundColor: Colors.red);
                  
                } else {
                  this.form_status = 0;
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT,
                        gravity: Toast.BOTTOM,
                        backgroundColor: Colors.red);
                  } else {
                    Navigator.pushReplacementNamed(context, '/mainpage');
                    userid.text = "";
                    password.text = "";
                  }
                }
              },
            ),
            FlatButton(
              child: Container(
                child: Text("register new user", textAlign: TextAlign.right),
              ),
              onPressed: () {
                userid.text = '';
                password.text = '';
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
