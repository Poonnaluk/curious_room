import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/room/createroom.dart';
import 'package:curious_room/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/loginController.dart';

// void main(List<String> args) {
//   runApp(First());
// }

// class First extends StatelessWidget {
//   const First({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//      return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FirstPage(),
//       theme: ThemeData(fontFamily: 'Prompt'),
//     );
//   }
// }

// ignore: must_be_immutable
class FirstPage extends StatefulWidget {
  FirstPage({Key? key, this.info}) : super(key: key);
  UserModel? info;
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late double screenw;
  late double screenh;
  String ip = 'http://192.168.1.48:8000/';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final textCodeController = TextEditingController();
  bool isTextFiledFocus = false;
  final _formKey = new GlobalKey<FormState>();

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        shadowColor: Color.fromRGBO(233, 160, 151, 1),
        backgroundColor: Colors.white,
        toolbarHeight: screenh * 0.1,
        title: Text(
          'Curius Room',
          style: TextStyle(
              fontSize: 22.sp, color: Color.fromRGBO(176, 162, 148, 1)),
        ),
        leading: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            onPressed: () {
              print(ip + widget.info!.display);
              _key.currentState!.openDrawer();
            }, //,
            icon: Image.asset(
              'assets/images/menu2.png',
              fit: BoxFit.fill,
            ),
            // iconSize: 50,
          ),
        ),
        actions: [
          AspectRatio(
            aspectRatio: 0.8,
            child: IconButton(
              icon: Image.asset(
                'assets/images/createRoom.png',
                fit: BoxFit.fill,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatRoomPage()));
              },
            ),
          ),
          SizedBox(
            width: screenw * 0.02,
          )
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
      ),
      drawer: MyMenu(url: ip + widget.info!.display),
      body: SafeArea(
        child: Container(
            //ห้องที่เข้าร่วมแล้ว
            ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Transform.scale(
          scale: 1.2,
          child: FloatingActionButton(
            onPressed: () {
              joinRoom(context);
            },
            child: Image.asset(
              'assets/icons/join.png',
              fit: BoxFit.contain,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<dynamic> joinRoom(BuildContext context) {
    return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenh * 0.2,
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          content: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '#',
                                style: TextStyle(fontSize: 19.sp),
                              ),
                              Expanded(
                                  child: Form(
                                key: _formKey,
                                child: Focus(
                                  onFocusChange: (value) {
                                    setState(() {
                                      isTextFiledFocus = value;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: textCodeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: 'กรอกรหัสเพื่อเข้าร่วม',
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              )),
                              IconButton(
                                  onPressed: () {},
                                  icon: !isTextFiledFocus
                                      ? Image.asset(
                                          'assets/icons/Join_button_gray.png')
                                      : Image.asset(
                                          'assets/icons/Join_button_green.png'))
                            ],
                          ),
                        );
                      })
                    ],
                  );
                });
  }

  // ignore: non_constant_identifier_name
}
