import 'dart:async';
import 'package:uts/Models/User.dart';
import 'package:uts/DbHelper/DbHelper.dart';

class LoginRequest {
  DbHelper dbHelper = new DbHelper();
 Future<User> getLogin(String username, String password) {
    var result = dbHelper.getLogin(username,password);
    return result;
  }
}