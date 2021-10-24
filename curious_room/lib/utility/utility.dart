// ignore: duplicate_ignore
// ignore: unused_import
// ignore_for_file: unused_import, unused_local_variable
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/controllers/loginController.dart';

import 'package:curious_room/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


//เมนูบาร์
// ignore: non_constant_identifier_names, must_be_immutable
class MyMenu extends StatelessWidget {
  MyMenu({Key? key, this.url}) : super(key: key);
  String? url;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    late double screenw;
    late double screenh;
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    String ipTest = 'http://192.168.1.48:8000/null';
    String image;
    if (controller.googleAccount.value!.photoUrl.toString() != "null") {
      image = controller.googleAccount.value!.photoUrl.toString();
    } else if (url != ipTest) {
      image = url.toString();
    } else {
      image = 'null';
    }

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text(
                'Curious Room',
                style: textStyle(),
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
              child: ListTile(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                      radius: 25,
                      backgroundImage: image == "null"
                          ? Image.asset('assets/images/logoIcon.png').image
                          : Image.network('$image').image,
                      onBackgroundImageError: (exception, context) {
                        print('$image Cannot be loaded');
                      },
                    ),
                    SizedBox(
                      width: screenw * 0.01,
                    ),
                    Text(
                      controller.googleAccount.value!.displayName ??
                          "User Name",
                      style: textStyle(),
                    )
                  ],
                ),
                // selected: true,
                // selectedTileColor: Color.fromRGBO(117, 195, 185, 1),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
            ListTile(
              title: Text(
                'ห้องของฉัน',
                style: textStyle(),
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/SignOut.png'),
                      radius: 25.0,
                    ),
                    SizedBox(
                      width: screenw * 0.02,
                    ),
                    Text(
                      'Sign out',
                      style: textStyle(),
                    )
                  ],
                ),
              ),
              // selected: true,
              // selectedTileColor: Color.fromRGBO(117, 195, 185, 1),
              onTap: () async {
                await controller.signout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(176, 162, 148, 1),
        fontWeight: FontWeight.w600);
  }
}