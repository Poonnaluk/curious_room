import 'dart:io';
import 'dart:math';
import 'package:curious_room/Models/PostHistory.dart';
import 'package:curious_room/Models/VoteModel.dart';
import 'package:curious_room/Views/room/statisticRoom.dart';
import 'package:curious_room/Views/comment/commentPage.dart';
import 'package:curious_room/Views/room/postHistory.dart';
import 'package:curious_room/Views/utility/alertDialog.dart';
import 'package:curious_room/Views/utility/finishDialog.dart';
import 'package:curious_room/Views/utility/showImage.dart';
import 'package:http/http.dart' as http;
import 'package:curious_room/Models/PostModel.dart';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Post/createPost.dart';
import 'package:curious_room/Views/Post/editPost.dart';
import 'package:curious_room/Views/room/aboutRoomPage.dart';
import 'package:curious_room/Views/utility/themeMoreButton.dart';
import 'package:curious_room/Views/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
  late Future<List<PostModel>> filter;
  late List<PostModel> value;
  late RoomModel room;
  // responsive
  late double screenw;
  late double screenh;
  File? _image;
  bool chooseNew = true;
  bool chooseHots = false;
//เช็ค role
  bool isownerpost = false;
  bool isownerroom = false;
  bool isAdmin = false;
  //เช็คเคยแก้ไขหรือไม่
  get async => null;
  bool isLoading = false;
  Future<List<PostHistoryModel>> history = Future.value([]);

  @override
  initState() {
    super.initState();
    future = getPost(widget.roomModel.id, widget.userModel.id, false);
    filter = getPost(widget.roomModel.id, widget.userModel.id, true);
    room = widget.roomModel;
  }

  Future<dynamic> refreshData() async {
    try {
      future = await Future.value(
          getPost(widget.roomModel.id, widget.userModel.id, false));
      filter = await Future.value(
          getPost(widget.roomModel.id, widget.userModel.id, true));
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void isloadingNow(bool loadNow) {
    if (mounted) {
      if (loadNow) {
        setState(() {
          isLoading = loadNow;
        });
      } else {
        setState(() {
          isLoading = loadNow;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    String subname;
    int nameLenght;
    _image = null;
    print(room.name);

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StatisticPage(roomid: room.id)));
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
          page: '/roompage',
        ),
        body: SafeArea(
            child: Center(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
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
                    // chooseNew == true
                    //     ?
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        await refreshData();
                        await Future.delayed(Duration(milliseconds: 1000));
                      },
                      child: FutureBuilder<List<PostModel>>(
                          future: chooseNew == true ? future : filter,
                          builder: (context, snapshot) {
                            if (snapshot.data.toString() == "[]") {
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
                              return ListView.builder(
                                  itemCount: value.length - 1,
                                  itemBuilder: (context, index) {
                                    print(
                                        value.last.listVoteStatus!.runtimeType);
                                    //เปลี่ยนไทม์โซน
                                    String time = DateFormat('Hm').format(
                                        value[index].createdAt!.toLocal());
                                    String date =
                                        '${DateFormat.yMMMd().format(value[index].createdAt!.toLocal())}';
                                    //เช็คความยาวชื่อ
                                    nameLenght =
                                        (value[index].userPost.name).length;
                                    nameLenght < 17
                                        ? subname = value[index].userPost.name
                                        : subname =
                                            '${value[index].userPost.name.substring(0, 17)}...';
                                    widget.userModel.id == widget.ownerModel.id
                                        ? isownerroom = true
                                        : isownerroom = false;

                                    widget.userModel.id ==
                                            value[index].userPost.id
                                        ? isownerpost = true
                                        : isownerpost = false;
                                    widget.userModel.role == "USER"
                                        ? isAdmin = false
                                        : isAdmin = true;
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
                                                crossAxisAlignment: widget
                                                            .userModel.role ==
                                                        "USER"
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      widget.userModel.role ==
                                                              "USER"
                                                          ? IconButton(
                                                              icon: value.last.listVoteStatus![
                                                                          index] ==
                                                                      1
                                                                  ? Image.asset(
                                                                      'assets/icons/upvote.png')
                                                                  : Image.asset(
                                                                      'assets/icons/upvote_gray.png'),
                                                              iconSize: 30,
                                                              onPressed:
                                                                  () async {
                                                                //ส่งค่าการโหวตแล้วรีเฟรข
                                                                await voteScore(
                                                                        1,
                                                                        widget
                                                                            .userModel
                                                                            .id,
                                                                        value[index]
                                                                            .id)
                                                                    .then((value) =>
                                                                        refreshData());
                                                              },
                                                            )
                                                          : SizedBox(),
                                                      Container(
                                                        margin: widget.userModel
                                                                    .role ==
                                                                "USER"
                                                            ? EdgeInsets.all(0)
                                                            : EdgeInsets.only(
                                                                left: 20,
                                                                right: 20),
                                                        child: Text(value[index]
                                                            .countVote
                                                            .toString()),
                                                      ),
                                                      widget.userModel.role ==
                                                              "USER"
                                                          ? IconButton(
                                                              icon: value.last.listVoteStatus![
                                                                          index] ==
                                                                      0
                                                                  ? Image.asset(
                                                                      'assets/icons/downvote.png')
                                                                  : Image.asset(
                                                                      'assets/icons/downvote_gray.png'),
                                                              iconSize: 30,
                                                              onPressed:
                                                                  () async {
                                                                //ส่งค่าการโหวตแล้วรีเฟรข
                                                                await voteScore(
                                                                        0,
                                                                        widget
                                                                            .userModel
                                                                            .id,
                                                                        value[index]
                                                                            .id)
                                                                    .then((value) =>
                                                                        refreshData());
                                                              },
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  // crossAxisAlignment:
                                                                  //     CrossAxisAlignment.start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor: Color.fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0),
                                                                      radius:
                                                                          20.5,
                                                                      backgroundImage:
                                                                          Image.network((value[index].userPost.display).toString())
                                                                              .image,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          4.w,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          (subname),
                                                                          style:
                                                                              text(16.8),
                                                                        ),
                                                                        Text(
                                                                          date,
                                                                          style:
                                                                              text(14.8),
                                                                        ),
                                                                        Text(
                                                                          time,
                                                                          style:
                                                                              text(14.8),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  //เช็ค Role
                                                                  widget.userModel
                                                                              .id ==
                                                                          widget
                                                                              .ownerModel
                                                                              .id
                                                                      ? isownerroom =
                                                                          true
                                                                      : isownerroom =
                                                                          false;

                                                                  widget.userModel
                                                                              .id ==
                                                                          value[index]
                                                                              .userPost
                                                                              .id
                                                                      ? isownerpost =
                                                                          true
                                                                      : isownerpost =
                                                                          false;

                                                                  moreBotton(
                                                                      context,
                                                                      value[index]
                                                                          .id!,
                                                                      value[index]
                                                                          .userPost,
                                                                      value[index]
                                                                          .postHistory!
                                                                          .content,
                                                                      value[index]
                                                                          .postHistory!
                                                                          .image
                                                                          .toString(),
                                                                      isownerroom,
                                                                      isownerpost,
                                                                      isAdmin);
                                                                },
                                                                icon:
                                                                    Image.asset(
                                                                  'assets/icons/more_icon.png',
                                                                ))
                                                            // : SizedBox(),
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
                                                                .postHistory!
                                                                .content,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value[index].postHistory!.image ==
                                                      null
                                                  ? Container()
                                                  : GestureDetector(
                                                      child: Container(
                                                          width: 80.w,
                                                          height: 30.h,
                                                          child: Image(
                                                            image: NetworkImage(
                                                                value[index]
                                                                    .postHistory!
                                                                    .image
                                                                    .toString()),
                                                          )),
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (_) {
                                                          return ImageScreen(
                                                            uri: value[index]
                                                                .postHistory!
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
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (_) {
                                                              return CommentPage(
                                                                postId:
                                                                    value[index]
                                                                        .id,
                                                                score: value[
                                                                        index]
                                                                    .countVote
                                                                    .toString(),
                                                                ownerId: value[
                                                                        index]
                                                                    .userPost
                                                                    .id,
                                                              );
                                                            },
                                                          ));
                                                        },
                                                        child: Text(
                                                          'เพิ่มคำตอบของคุณ...',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      176,
                                                                      162,
                                                                      148,
                                                                      1)),
                                                        ))
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
                          }),
                    ))
                  ],
                )),
        )),
      );
    }
  }

  moreBotton(
      BuildContext context,
      int postid,
      UserModel userModel,
      String content,
      String image,
      bool ownerroom,
      bool ownerpost,
      bool isadmin) async {
    dynamic value;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, setState) => isLoading
                        ? SizedBox()
                        : Wrap(
                            children: [
                              ownerpost
                                  ? TextButton(
                                      onPressed: () async {
                                        if (image.toString() != "null") {
                                          setState(() {
                                            isloadingNow(true);
                                          });
                                          try {
                                            await urlToFile(image);
                                          } finally {
                                            setState(() {
                                              isloadingNow(false);
                                            });
                                          }
                                        }
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return EditPostPage(
                                            content: content,
                                            images: _image,
                                            postId: postid,
                                            userModel: userModel,
                                            ownerModel: widget.ownerModel,
                                            roomModel: widget.roomModel,
                                          );
                                        }));
                                      },
                                      child: themeMoreButton(
                                          'assets/icons/edit_icon.png',
                                          'แก้ไข',
                                          16))
                                  : SizedBox(),
                              Container(
                                  height: 1,
                                  color: Color.fromRGBO(107, 103, 98, 1.0)),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                          builder: (context) => new HistoryPage(
                                                postid: postid,
                                              )));
                                },
                                child: themeMoreButton(
                                    'assets/icons/historyPost.png',
                                    'ดูประวัติการแก้ไข',
                                    17),
                              ),
                              Container(
                                  height: 1,
                                  color: Color.fromRGBO(107, 103, 98, 1.0)),
                              ownerroom || ownerpost || isadmin
                                  ? TextButton(
                                      onPressed: () async {
                                        value = await confirmDialog(context,
                                            'หากคุณลบโพสต์ของคุณสถิตของโพสต์นี้ของคุณจะหายไป');
                                        if (value == 'true') {
                                          print(postid);
                                          final snackBar = SnackBar(
                                            content:
                                                const Text('ลบโพสต์ไม่สำเร็จ'),
                                          );

                                          setState(() {
                                            isloadingNow(true);
                                          });

                                          // isSuccess = await deletePost(postid);
                                          deletePost(postid)
                                              .then((isSuccess) async {
                                            await successDialog(
                                                context, 'ลบโพสต์สำเร็จ');
                                            if (isSuccess) {
                                              Navigator.pop(context);
                                              await refreshData();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }

                                            isloadingNow(false);
                                          });
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: themeMoreButton(
                                          'assets/icons/delete_icon.png',
                                          'ลบ',
                                          20))
                                  : SizedBox(),
                              Container(
                                  height: 1,
                                  color: Color.fromRGBO(107, 103, 98, 1.0)),
                            ],
                          ));
              });
        });
  }

  //เปลี่ยน type string to file
  Future<File?> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File? file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    _image = file;
    file = null;
    return _image;
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
