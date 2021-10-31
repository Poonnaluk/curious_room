import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Post/createPost.dart';
import 'package:curious_room/room/aboutRoomPage.dart';
import 'package:curious_room/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoomPage extends StatefulWidget {
  final UserModel userModel;
  final RoomModel roomModel;
  final UserModel ownerModel;
  const RoomPage({
    Key? key,
    required this.userModel,
    required this.roomModel,
    required this.ownerModel,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late RoomModel room;

  // resposive
  late double screenw;
  late double screenh;

  bool chooseNew = true;
  bool chooseHots = false;

  @override
  void initState() {
    super.initState();
    room = widget.roomModel;
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text(
            room.name,
          ),
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(176, 162, 148, 1),
              fontSize: 21.5.sp,
              fontFamily: 'Prompt'),
          leading: Transform.scale(
            scale: 0.7,
            child: IconButton(
              onPressed: () => _key.currentState!.openDrawer(), //,
              icon: Image.asset(
                'assets/images/menu2.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: [
            Transform.scale(
              scale: 0.8,
              child: IconButton(
                onPressed: () {
                  // Navigator.of(context).push();
                },
                icon: Image.asset(
                  'assets/icons/stat_icon.png',
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                print(
                    "owner display >> " + widget.ownerModel.display.toString());
                final roomname = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutRoomPage(
                            roomModel: room,
                            ownerModel: widget.ownerModel,
                            userModel: widget.userModel)));
                setState(() {
                  room.name = roomname.toString();
                });
              },
              icon: Image.asset('assets/icons/about_icon.png'),
            ),
            SizedBox(
              width: screenw * 0.02,
            )
          ],
        ),
        drawer: MyMenu(
          userModel: widget.userModel,
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
          screenw * 0.005, screenh * 0.02, screenw * 0.005, screenh * 0.01),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.only(
                left: 31.0, top: 27.5, right: 160.5, bottom: 27.5),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                    color: Color.fromRGBO(176, 162, 148, 1), width: 1))),
        child: Text(
          'แชร์สิ่งที่กำลังสัยอยู่...',
          style: TextStyle(fontSize: 17.sp),
        ),
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CreatePost(
              userModel: widget.userModel,
            ),
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
                left: 20.5, top: 10, right: 20.5, bottom: 10),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                    color: button
                        ? Color.fromRGBO(225, 141, 63, 1)
                        : Color.fromRGBO(176, 162, 148, 1),
                    width: 1.w))),
        child: Text(
          textbutton,
          style: TextStyle(fontSize: 17.5.sp),
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
                left: 20.5, top: 10, right: 20.5, bottom: 10),
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
          style: TextStyle(fontSize: 17.5.sp),
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
