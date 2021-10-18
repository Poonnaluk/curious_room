import 'package:curious_room/Post/createPost.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String projectName;
  final int userid;
  const RoomPage({Key? key, required this.projectName, required this.userid})
      : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  // resposive
  late double screenw;
  late double screenh;

  bool chooseNew = true;
  bool chooseHots = false;

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text(
            widget.projectName,
          ),
          titleTextStyle: const TextStyle(
              color: Color.fromRGBO(176, 162, 148, 1),
              fontSize: 28,
              fontFamily: 'Prompt'),
          leading: Icon(
            Icons.menu,
            color: Colors.red,
            size: 50,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/stat_icon.png',
              ),
              iconSize: 40,
            ),
            IconButton(
                onPressed: () {},
                icon: Image.asset('assets/icons/about_icon.png')),
            SizedBox(
              width: screenw * 0.02,
            )
          ],
        ),
        body: SafeArea(
            child: Center(
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildButtonCreate()]),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(35, 5, 10, 0),
                    child: _buttonNew('ล่าสุด', chooseNew),
                  ),
                  _buttonHots('ยอดนิยม', chooseHots),
                ],
              )
            ],
          )),
        )),
      );
    }
  }

  Widget _buildButtonCreate() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          screenw * 0.010, screenh * 0.02, screenw * 0.010, screenh * 0.01),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.only(
                left: 66.5, top: 42.5, right: 306.5, bottom: 42.5),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                    color: Color.fromRGBO(176, 162, 148, 1), width: 1))),
        child: Text(
          'แชร์สิ่งที่กำลังสัยอยู่...',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CreatePost(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  Widget _buttonNew(String textbutton, bool button) {
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.only(
                left: 32.5, top: 21, right: 32.5, bottom: 21),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                    color: button
                        ? Color.fromRGBO(225, 141, 63, 1)
                        : Color.fromRGBO(176, 162, 148, 1),
                    width: 3))),
        child: Text(
          textbutton,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            chooseNew = true;
            chooseHots = false;
          });
        },
      ),
    );
  }

  Widget _buttonHots(String textbutton, bool button) {
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.only(
                left: 32.5, top: 21, right: 32.5, bottom: 21),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                    color: button == true
                        ? Color.fromRGBO(225, 141, 63, 1)
                        : Color.fromRGBO(176, 162, 148, 1),
                    width: 3))),
        child: Text(
          textbutton,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          setState(() {
            chooseHots = true;
            chooseNew = false;
          });
        },
      ),
    );
  }
}
