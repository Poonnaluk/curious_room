// ignore: duplicate_ignore
// ignore: unused_import
// ignore_for_file: unused_import, unused_local_variable
import 'dart:io';

import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/profile/screen/profile.dart';
import 'package:curious_room/controllers/loginController.dart';

import 'package:curious_room/main.dart';
import 'package:curious_room/Views/room/roompage.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../firstpage.dart';

class MyMenu extends StatefulWidget {
  final String page;

  MyMenu({Key? key, required this.page}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MyMenuState();
}

//เมนูบาร์
class MyMenuState extends State<MyMenu> {
  UserModel? userModel;
  Future<List<RoomModel>>? future = Future.value(<RoomModel>[]);
  late List<RoomModel>? value;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    late double screenw;
    late double screenh;
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    userModel = context.watch<UserProvider>().userModel;
    String imge = userModel!.display.toString();
    future = getMyRoom(userModel!.id);
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
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => FirstPage()),
                    (Route<dynamic> route) => false);
              },
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
                      backgroundImage:
                          userModel!.display.runtimeType.toString() == "_File"
                              ? Image.file(userModel!.display).image
                              : Image.network(imge).image,
                      onBackgroundImageError: (exception, context) {
                        print('${userModel!.display} Cannot be loaded');
                      },
                    ),
                    SizedBox(
                      width: screenw * 0.01,
                    ),
                    Text(
                      userModel!.name,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              userModel: userModel!,
                              page: 'menubar',
                            )),
                  );
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
                style: TextStyle(
                    fontSize: 16.5.sp,
                    color: Color.fromRGBO(176, 162, 148, 1),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Transform.scale(
                scale: 1,
                child: FutureBuilder<List<RoomModel>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.data == []) {
                      return Container(
                          padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                          child: Text(
                            'ยังไม่ได้สร้างห้อง',
                            style: TextStyle(
                                color: Color.fromRGBO(176, 162, 148, 1.0)),
                          ));
                    } else if (snapshot.hasData) {
                      value = snapshot.data;
                      return new ListView.builder(
                          shrinkWrap: true,
                          itemCount: value!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              visualDensity: VisualDensity(
                                horizontal: -4,
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    width: 5.w,
                                  ),
                                  Text(
                                    (value?[index].name).toString(),
                                    style: textStyle(),
                                  ),
                                ],
                              ),
                              onTap: () {
                                RoomModel roomModel = new RoomModel(
                                    id: value![index].id,
                                    name: value![index].name,
                                    code: value![index].code,
                                    userId: value![index].userId,
                                    createdAt: value![index].createdAt,
                                    updatedAt: value![index].updatedAt,
                                    ownerModel: value![index].ownerModel);
                                if (widget.page == '/firstpage') {
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                          builder: (context) => new RoomPage(
                                                userModel: userModel!,
                                                roomModel: roomModel,
                                                ownerModel: userModel!,
                                              )));
                                } else {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: '/roompage'),
                                          builder: (context) => new RoomPage(
                                                userModel: userModel!,
                                                roomModel: roomModel,
                                                ownerModel: userModel!,
                                              )));
                                }
                              },
                            );
                          });
                    }
                    return Center(
                      child: LinearProgressIndicator(),
                    );
                  },
                )),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                );
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
        fontSize: 18.sp,
        color: Color.fromRGBO(176, 162, 148, 1),
        fontWeight: FontWeight.w600);
  }
}
