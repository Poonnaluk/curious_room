import 'dart:io';

import 'package:curious_room/Models/UserModel.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  File? file;
  UserProvider();

  setUser(UserModel user) {
    userModel = user;
  }

  setImgFile(File _file) {
    file = _file;
  }
}
