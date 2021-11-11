import 'package:curious_room/Models/PostModel.dart';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Post/createPost.dart';
import 'package:curious_room/Views/room/aboutRoomPage.dart';
import 'package:curious_room/Views/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:vector_math/vector_math_64.dart' show Vector3;

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
  late Future<List<PostModel>> future;
  late List<PostModel> value;
  late RoomModel room;
  // resposive
  late double screenw;
  late double screenh;

  bool chooseNew = true;
  bool chooseHots = false;

  @override
  void initState() {
    super.initState();
    future = getPost(widget.roomModel.id);
    room = widget.roomModel;
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    String subname;
    int nameLenght;

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
          page: '/roompage',
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
                    padding: EdgeInsets.fromLTRB(22, 0, 10, 0),
                    child: _buttonNew('ล่าสุด', chooseNew),
                  ),
                  _buttonHots('ยอดนิยม', chooseHots),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              chooseNew == true
                  ? Expanded(
                      child: FutureBuilder<List<PostModel>>(
                          future: future,
                          builder: (context, snapshot) {
                            if (snapshot.data == []) {
                              return Center(
                                child: Text(
                                  'ยังไม่มีโพสต์',
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(176, 162, 148, 1.0)),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              value = snapshot.data!;
                              print(value);
                              return ListView.builder(
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    String time = DateFormat('Hm').format(
                                        value[index].createdAt.toLocal());
                                    String date =
                                        '${DateFormat.yMMMd().format(value[index].createdAt.toLocal())}';
                                    nameLenght =
                                        (value[index].userPost.name).length;
                                    nameLenght < 17
                                        ? subname = value[index].userPost.name
                                        : subname = value[index]
                                            .userPost
                                            .name
                                            .substring(0, 17);
                                    return ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      title: Transform.scale(
                                        scale: 1,
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    176, 162, 148, 1),
                                              )),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Image.asset(
                                                            'assets/icons/upvote_gray.png'),
                                                        iconSize: 30,
                                                        onPressed: () {},
                                                      ),
                                                      Text('0'),
                                                      IconButton(
                                                        icon: Image.asset(
                                                            'assets/icons/downvote_gray.png'),
                                                        iconSize: 30,
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0),
                                                              radius: 20.5,
                                                              backgroundImage: Image.network((value[
                                                                              index]
                                                                          .userPost
                                                                          .display)
                                                                      .toString())
                                                                  .image,
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                nameLenght < 17
                                                                    ? Text(
                                                                        (subname),
                                                                        style: text(
                                                                            16.8),
                                                                      )
                                                                    : Text(
                                                                        (subname +
                                                                            '...'),
                                                                        style: text(
                                                                            16.8),
                                                                      ),
                                                                Text(
                                                                  date,
                                                                  style: text(
                                                                      14.8),
                                                                ),
                                                                Text(
                                                                  time,
                                                                  style: text(
                                                                      14.8),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 2.w),
                                                          child: Text(
                                                            value[index]
                                                                .postHistory
                                                                .first
                                                                .content,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value[index]
                                                          .postHistory
                                                          .first
                                                          .image ==
                                                      null
                                                  ? Container()
                                                  : GestureDetector(
                                                      child: Container(
                                                          width: 80.w,
                                                          height: 30.h,
                                                          child: Image(
                                                            image: NetworkImage(
                                                                value[index]
                                                                    .postHistory
                                                                    .first
                                                                    .image
                                                                    .toString()),
                                                          )),
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (_) {
                                                          return ImageScreen(
                                                            uri: value[index]
                                                                .postHistory
                                                                .first
                                                                .image
                                                                .toString(),
                                                          );
                                                        }));
                                                      }),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                height: 1,
                                                color: Color.fromRGBO(
                                                    176, 162, 148, 1),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'เพิ่มคำตอบของคุณ...',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              176,
                                                              162,
                                                              148,
                                                              1)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }))
                  : Center(
                      child: Text("หน้าแสดง ยอดนิยม"),
                    ),
            ],
          )),
        )),
      );
    }
  }

  TextStyle text(double s) {
    return TextStyle(
        color: Color.fromRGBO(107, 103, 98, 1),
        fontSize: s.sp,
        fontFamily: 'Prompt');
  }

  Widget _buildButtonCreate() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          // screenw * 0.04, screenh * 0.0, screenw * 0, screenh * 0.01),
          1.w,
          1.h,
          1.w,
          1.h),
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            primary: Color.fromRGBO(107, 103, 98, 1),
            backgroundColor: Colors.white,
            padding: EdgeInsets.fromLTRB(3.w, 4.h, 57.w, 4.h),
            shadowColor: Color.fromRGBO(176, 162, 148, 1),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                    color: Color.fromRGBO(176, 162, 148, 1), width: 1))),
        child: Text(
          'แชร์สิ่งที่กำลังสัยอยู่...',
          style: TextStyle(fontSize: 15.5.sp),
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
              ownerModel: widget.ownerModel,
              roomModel: room,
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
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
                    width: 3))),
        child: Text(
          textbutton,
          style: TextStyle(fontSize: 15.5.sp),
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
            backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
          style: TextStyle(fontSize: 15.5.sp),
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

// ignore: must_be_immutable
class ImageScreen extends StatefulWidget {
  ImageScreen({Key? key, required this.uri}) : super(key: key);
  String uri;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2,
                imageProvider: NetworkImage(
                  widget.uri,
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
