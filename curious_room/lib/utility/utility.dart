import 'package:curious_room/controllers/loginController.dart';
import 'package:curious_room/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

//dialog อันเดียวกับการาจ
// Future<Null> normalDialog(
//     BuildContext context, String string1, String string2, int time) async {
//   showDialog(
//     context: context,
//     builder: (context) => OneTimeDialog(
//       amountOfTimesToShow: time,
//       title: ListTile(
//         title: Text(
//           string1,
//           style: TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(string2),
//       ),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
//       ],
//       context: context,
//       id: 'AUniqueID',
//     ),
//   );
// }

//เมนูบาร์
// ignore: non_constant_identifier_names
class MyMenu extends StatelessWidget {
  const MyMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    late double screenw;
    screenw = MediaQuery.of(context).size.width;
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
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                        backgroundImage:
                            controller.googleAccount.value!.photoUrl == null
                                ? AssetImage("assets/images/logoIcon.png")
                                : Image.network(controller
                                        .googleAccount.value!.photoUrl
                                        .toString())
                                    .image,
                        radius: 24,
                      ),
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
                      width: screenw * 0.01,
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
        fontSize: 21,
        color: Color.fromRGBO(176, 162, 148, 1),
        fontWeight: FontWeight.w600);
  }
}
