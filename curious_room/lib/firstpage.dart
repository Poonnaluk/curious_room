import 'package:curious_room/room/createroom.dart';
import 'package:curious_room/utility/utility.dart';
import 'package:flutter/material.dart';

import 'Models/UserModel.dart';

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

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, this.info}) : super(key: key);
  final UserModel? info;
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late double screenw;
  late double screenh;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
          key: _key,
          appBar: AppBar(
            shadowColor: Color.fromRGBO(233, 160, 151, 1),
            backgroundColor: Colors.white,
            toolbarHeight: screenh * 0.1,
            title: Text(
              'Classroom Q&A',
              style: TextStyle(
                  fontSize: 50, color: Color.fromRGBO(176, 162, 148, 1)),
            ),
            leading: IconButton(
              onPressed: () => _key.currentState!.openDrawer(), //,
              icon: Image.asset(
                'assets/images/menu2.png',
                fit: BoxFit.cover,
              ),
              iconSize: 50,
            ),
            actions: [
              IconButton(
                icon: Image.asset(
                  'assets/images/createRoom.png',
                  fit: BoxFit.fill,
                ),
                iconSize: 78,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreatRoomPage()));
                },
              ),
              SizedBox(
                width: screenw * 0.02,
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(50))),
          ),
          drawer: MyMenu(),
          body: SafeArea(
            child: Container(
                //   decoration: BoxDecoration(border: Border(),
                // ),
                ),
          ));
    }
  }
}
