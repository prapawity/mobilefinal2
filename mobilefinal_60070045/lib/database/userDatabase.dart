import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String idColumn = "_id";
final String useridColumn = "userid";
final String nameColumn = "name";
final String ageColumn = "age";
final String passwordColumn = "password";
final String quoteColumn = "quote";

class User_information {
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;
  User_information();
  User_information.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.userid = map[useridColumn];
    this.name = map[nameColumn];
    this.age = map[ageColumn];
    this.password = map[passwordColumn];
    this.quote = map[quoteColumn];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridColumn: userid,
      nameColumn: name,
      ageColumn: age,
      passwordColumn: password,
      quoteColumn: quote,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'id: ${this.id}, userid:  ${this.userid}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}';
  }
}

class User_data {
  Database database;
  Future open(String path) async {
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $idColumn integer primary key autoincrement,
        $useridColumn text not null unique,
        $nameColumn text not null,
        $ageColumn text not null,
        $passwordColumn text not null,
        $quoteColumn text
      )
      ''');
    });
  }

  Future<User_information> getUser(int id) async {
    List<Map<String, dynamic>> maps = await database.query(userTable,
        columns: [
          idColumn,
          useridColumn,
          nameColumn,
          ageColumn,
          passwordColumn,
          quoteColumn
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    maps.length > 0 ? new User_information.formMap(maps.first) : null;
  }

  Future<int> updateUser(User_information user) async {
    return database.update(userTable, user.toMap(),
        where: '$idColumn = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    return await database
        .delete(userTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<List<User_information>> getAllUser() async {
    await this.open("user.db");
    var res = await database.query(userTable, columns: [
      idColumn,
      useridColumn,
      nameColumn,
      ageColumn,
      passwordColumn,
      quoteColumn
    ]);
    List<User_information> userList = res.isNotEmpty
        ? res.map((c) => User_information.formMap(c)).toList()
        : [];
    return userList;
  }

  Future<User_information> insertUser(User_information user) async {
    user.id = await database.insert(userTable, user.toMap());
    return user;
  }

  Future close() async => database.close();
}
