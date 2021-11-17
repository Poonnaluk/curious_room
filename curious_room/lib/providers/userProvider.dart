import 'package:curious_room/Models/UserModel.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserProvider();

  setUser(UserModel user) {
    userModel = user;
  }
  
}
