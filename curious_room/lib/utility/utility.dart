import 'package:curious_room/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:one_time_dialog/one_time_dialog.dart';

//dialog อันเดียวกับการาจ
Future<Null> normalDialog(
    BuildContext context, String string1, String string2, int time) async {
  showDialog(
    context: context,
    builder: (context) => OneTimeDialog(
      amountOfTimesToShow: time,
      title: ListTile(
        title: Text(
          string1,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(string2),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
      ],
      context: context,
      id: 'AUniqueID',
    ),
  );
}

//เมนูบาร์
// ignore: non_constant_identifier_names
class MyMenu extends StatelessWidget {
  const MyMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late double screenw;
    late double screenh;
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
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
                        backgroundImage: NetworkImage(
                            "https://images.workpointnews.com/workpointnews/2019/05/31123711/1559281027_83580_cd86115188a0c135bb67874d342a9be80_14286846_181229_0003.jpg"),
                        radius: 25.0,
                      ),
                    ),
                    SizedBox(
                      width: screenw * 0.01,
                    ),
                    Text(
                      'UserName',
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
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
