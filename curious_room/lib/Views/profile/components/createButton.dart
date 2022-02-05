import 'dart:io';

import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Style/color.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/Views/profile/screen/profile.dart';
import 'package:curious_room/Views/utility/finishDialog.dart';
import 'package:curious_room/controllers/loginController.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

buildEditPostButton(BuildContext context, File cropped) {
  UserModel? user = context.watch<UserProvider>().userModel;
  LoginController userController = LoginController();
  return Container(
    padding: EdgeInsets.all(8),
    alignment: Alignment.centerRight,
    child: TextButton(
      style: TextButton.styleFrom(
          backgroundColor: greenColor,
          padding: const EdgeInsets.all(10.0),
          primary: Colors.white,
          textStyle: normalTextStyle(15.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
      onPressed: () async {
        user!.display = cropped;
        context.read<UserProvider>().setUser(user);
        await userController.updateDisplay(user.id, "", cropped);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage(userModel: user),
          ),
        );
        await successDialog(context, "อัพโหลดรูปโปรไฟล์สำเร็จ");
      },
      child: Text(
        'บักทึก',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
