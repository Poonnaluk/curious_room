import 'package:curious_room/createRoom/createroom.dart';
import 'package:flutter/material.dart';

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
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late double screenw;
  late double screenh;
  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
          appBar: AppBar(
            shadowColor: Color.fromRGBO(233, 160, 151, 1),
            backgroundColor: Colors.white,
            toolbarHeight: screenh * 0.1,
            title: Text(
              'Classroom Q&A',
              style: TextStyle(
                  fontSize: 50, color: Color.fromRGBO(176, 162, 148, 1)),
            ),
            leading: Icon(
              Icons.menu,
              color: Colors.red,
              size: 50,
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
          body: SafeArea(
            child: Container(
                //   decoration: BoxDecoration(border: Border(),
                // ),
                ),
          ));
    }
  }
}
