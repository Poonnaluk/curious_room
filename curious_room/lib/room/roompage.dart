import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Post/createPost.dart';
import 'package:curious_room/room/aboutRoomPage.dart';
import 'package:curious_room/utility/utility.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final RoomModel roomModel;
  final UserModel ownerModel;
  const RoomPage({
    Key? key,
    required this.roomModel,
    required this.ownerModel,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text(
            widget.roomModel.name,
          ),
          titleTextStyle: const TextStyle(
              color: Color.fromRGBO(176, 162, 148, 1),
              fontSize: 28,
              fontFamily: 'Prompt'),
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
              onPressed: () {
                // Navigator.of(context).push();
              },
              icon: Image.asset(
                'assets/icons/stat_icon.png',
              ),
              iconSize: 35,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutRoomPage(
                              roomid: widget.roomModel.id,
                              roomName: widget.roomModel.name,
                              code: widget.roomModel.code,
                              ownerid: widget.roomModel.userId,
                              ownerName: widget.ownerModel.name,
                              ownerDisplay: widget.ownerModel.display,
                            )));
              },
              icon: Image.asset('assets/icons/about_icon.png'),
            ),
            SizedBox(
              width: screenw * 0.005,
            )
          ],
        ),
        drawer: MyMenu(),
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
                    padding: EdgeInsets.fromLTRB(31, 0, 10, 0),
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
          screenw * 0.005, screenh * 0.02, screenw * 0.005, screenh * 0.015),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.only(
                left: 31.0, top: 22.5, right: 160.5, bottom: 22.5),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                    color: Color.fromRGBO(176, 162, 148, 1), width: 1))),
        child: Text(
          'แชร์สิ่งที่กำลังสัยอยู่...',
          style: TextStyle(fontSize: 16),
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
                left: 20.5, top: 18, right: 20.5, bottom: 18),
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
          style: TextStyle(fontSize: 16),
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
                left: 20.5, top: 18, right: 20.5, bottom: 18),
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
          style: TextStyle(fontSize: 16),
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
