import 'package:curious_room/Models/ParticipateModel.dart';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
// import 'package:curious_room/controllers/roomController.dart';
import 'package:curious_room/room/createroom.dart';
import 'package:curious_room/room/roompage.dart';
import 'package:curious_room/utility/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Models/ParticipateModel.dart';
import 'controllers/loginController.dart';

// void main(List<String> args) {
//   runApp(First());
// }

// class First extends StatelessWidget {
//   const First({Key? key, required this.info}) : super(key: key);
//   final UserModel info;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FirstPage(
//         info: info,
//       ),
//       theme: ThemeData(fontFamily: 'Prompt'),
//     );
//   }
// }

// ignore: must_be_immutable
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.info}) : super(key: key);
  final UserModel info;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late double screenw;
  late double screenh;
  String ip = 'http://192.168.1.48:8000/';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isTextFiledFocus = false;
  final _formKey = new GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  late String code;
  dynamic room;

  // late Future<List<ParticipateModel>>? _partifuture;
  // late Future<List<RoomModel>>? _roomfuture;
  Future<List<ParticipateModel>>? _partifuture =
      Future.value(<ParticipateModel>[]);
  Future<List<RoomModel>>? _roomfuture = Future.value(<RoomModel>[]);

  late List<ParticipateModel>? value = [];
  late List<RoomModel>? value2 = [];
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    if (widget.info.role == 'USER') {
      _partifuture = getRoomParticipate(widget.info.id);
      _roomfuture = null;
      value2 = null;
    } else {
      _roomfuture = getAllRooms();
      _partifuture = null;
      value = null;
    }
  }

  Future onGoBack(dynamic value) async {
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      appBar: AppBar(
        shadowColor: Color.fromRGBO(233, 160, 151, 1),
        backgroundColor: Colors.white,
        toolbarHeight: screenh * 0.1,
        title: Text(
          'Curius Room',
          style: TextStyle(
              fontSize: 21.5.sp, color: Color.fromRGBO(176, 162, 148, 1)),
        ),
        leading: Transform.scale(
          scale: 0.7,
          child: IconButton(
            onPressed: () {
              print(widget.info.display);
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
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: AspectRatio(
              aspectRatio: 0.85,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/createRoom.png',
                  fit: BoxFit.fill,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatRoomPage(
                                userModel: widget.info,
                              )));
                },
              ),
            ),
          ),
          SizedBox(
            width: screenw * 0.05,
          )
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
      ),
      drawer: MyMenu(userModel: widget.info),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                Container(
                    child: Expanded(
                  child: widget.info.role == 'USER'
                      ? getMyRooms(context)
                      : getAllRoom(context),
                ))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Transform.scale(
          scale: 1.2,
          child: FloatingActionButton(
            onPressed: () {
              joinRoom(
                context,
              );
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
                List<RoomModel> roomWithOwnerUser;
                dynamic futureRoom;
                dynamic futrueParti;
                dynamic code;
                final textCodeController = TextEditingController();

                return AlertDialog(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
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
                            onChanged: (value) async {
                              code = value.trim();
                            },
                            controller: textCodeController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'กรอกรหัสเพื่อเข้าร่วม',
                              contentPadding: EdgeInsets.all(5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกรหัส';
                              }
                              return null;
                            },
                          ),
                        ),
                      )),
                      IconButton(
                          onPressed: () async {
                            print(textCodeController);
                            if (_formKey.currentState!.validate()) {
                              futureRoom =
                                  await (getRoomByCode(code.toString()));
                              if (futureRoom == null) {
                                final snackBar = SnackBar(
                                  content: const Text('รหัสไม่ถูกต้อง'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                roomWithOwnerUser = futureRoom;
                                print(widget.info.id.toString() +
                                    roomWithOwnerUser[0].id.toString());
                                futrueParti = await createParticipate(
                                    widget.info.id, roomWithOwnerUser[0].id);
                                if (futrueParti == null) {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: '/roompage'),
                                          builder: (context) => new RoomPage(
                                                userModel: widget.info,
                                                roomModel: roomWithOwnerUser[0],
                                                ownerModel: roomWithOwnerUser[0]
                                                    .ownerModel,
                                              )));
                                } else {
                                  final snackBar = SnackBar(
                                    content:
                                        const Text('คุณได้เข้าร่วมห้องนี้แล้ว'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            }
                          },
                          icon: !isTextFiledFocus
                              ? Image.asset('assets/icons/Join_button_gray.png')
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

  getMyRooms(BuildContext context) {
    return FutureBuilder<List<ParticipateModel>>(
        future: _partifuture,
        builder: (context, snapshot) {
          if (snapshot.data.toString() == "[]") {
            return Text(
              'คุณยังไม่ได้เข้าร่วมห้อง',
              style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
            );
          } else if (snapshot.hasData) {
            value = snapshot.data;
            return ListView.builder(
                itemCount: value!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        RoomModel roomModel = new RoomModel(
                            id: value![index].roomParticipate!.id,
                            name: value![index].roomParticipate!.name,
                            code: value![index].roomParticipate!.code,
                            userId: value![index].roomParticipate!.userId,
                            createdAt: value![index].roomParticipate!.createdAt,
                            updatedAt: value![index].roomParticipate!.updatedAt,
                            ownerModel:
                                value![index].roomParticipate!.ownerModel);
                        Navigator.of(context)
                            .push(new MaterialPageRoute(
                                builder: (context) => new RoomPage(
                                      userModel: widget.info,
                                      roomModel: roomModel,
                                      ownerModel: roomModel.ownerModel,
                                    )))
                            .then(onGoBack);
                      },
                      onHover: (hovering) {
                        setState(() {
                          isHovering = hovering;
                          print("hovering now");
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease,
                        margin: EdgeInsets.only(left: 0, top: 4.0),
                        padding: EdgeInsets.all(isHovering ? 50 : 30),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/card.png'),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        )),
                        child: Text(
                          (value?[index].roomParticipate?.name).toString(),
                          style: TextStyle(
                              color: Color.fromRGBO(107, 103, 98, 1.0),
                              fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ));
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  getAllRoom(BuildContext context) {
    return FutureBuilder<List<RoomModel>>(
        future: _roomfuture,
        builder: (context, snapshot) {
          if (snapshot.data.toString() == "[]") {
            return Text(
              'คุณยังไม่ได้เข้าร่วมห้อง',
              style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
            );
          } else if (snapshot.hasData) {
            value2 = snapshot.data;
            return ListView.builder(
                itemCount: value2!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        RoomModel roomModel = new RoomModel(
                            id: value2![index].id,
                            name: value2![index].name,
                            code: value2![index].code,
                            userId: value2![index].userId,
                            createdAt: value2![index].createdAt,
                            updatedAt: value2![index].updatedAt,
                            ownerModel: value2![index].ownerModel);
                        Navigator.of(context)
                            .push(new MaterialPageRoute(
                                builder: (context) => new RoomPage(
                                      userModel: widget.info,
                                      roomModel: roomModel,
                                      ownerModel: roomModel.ownerModel,
                                    )))
                            .then(onGoBack);
                      },
                      onHover: (hovering) {
                        setState(() {
                          isHovering = hovering;
                          print("hovering now");
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease,
                        margin: EdgeInsets.only(left: 0, top: 4.0),
                        padding: EdgeInsets.all(isHovering ? 50 : 30),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/card.png'),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        )),
                        child: Text(
                          (value2?[index].name).toString(),
                          style: TextStyle(
                              color: Color.fromRGBO(107, 103, 98, 1.0),
                              fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ));
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
  // ignore: non_constant_identifier_name
}
