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
  bool isTextFiledFocus = false;
  final _formKey = new GlobalKey<FormState>();
  final controller = Get.put(LoginController());

  late Future<List<ParticipateModel>> _roomfuture;
  late List<ParticipateModel>? value;

  @override
  void initState() {
    super.initState();
    _roomfuture = getRoomParticipate(widget.info!.id);
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    bool isHovering = false;

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
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: [
                Container(
                  child: Expanded(
                      child: FutureBuilder<List<ParticipateModel>>(
                          future: _roomfuture,
                          builder: (context, snapshot) {
                            if (snapshot.data.toString() == "[]") {
                              return Text(
                                'คุณยังไม่ได้เข้าร่วมห้อง',
                                style: TextStyle(
                                    color: Color.fromRGBO(176, 162, 148, 1.0)),
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
                                              id: value![index]
                                                  .roomParticipate!
                                                  .id,
                                              name: value![index]
                                                  .roomParticipate!
                                                  .name,
                                              code: value![index]
                                                  .roomParticipate!
                                                  .code,
                                              userId: value![index]
                                                  .roomParticipate!
                                                  .userId,
                                              createdAt: value![index]
                                                  .roomParticipate!
                                                  .createdAt,
                                              updatedAt: value![index]
                                                  .roomParticipate!
                                                  .updatedAt,
                                              ownerModel: value![index]
                                                  .roomParticipate!
                                                  .ownerModel);
                                          Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new RoomPage(
                                                        roomModel: roomModel,
                                                        ownerModel: roomModel
                                                            .ownerModel,
                                                      )));
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
                                          margin: EdgeInsets.only(
                                              left: 0, top: 4.0),
                                          padding: EdgeInsets.all(
                                              isHovering ? 50 : 30),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/card.png'),
                                            fit: BoxFit.fill,
                                            alignment: Alignment.topCenter,
                                          )),
                                          child: Text(
                                            (value?[index]
                                                    .roomParticipate
                                                    ?.name)
                                                .toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    107, 103, 98, 1.0),
                                                fontSize: 24),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                  });
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          })),
                )
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
                dynamic future;
                bool checkNull = true;
                late String checktype;
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
                              // if (value.length.toInt() == 7) {
                              //   future = await getRoomByCode(value.toString());
                              //   checktype = future.runtimeType.toString();
                              //   if (checktype == "Null") {
                              //     checkNull = true;
                              //   } else {
                              //     roomWithOwnerUser = future;
                              //     print(roomWithOwnerUser.first);
                              //     checkNull = false;

                              //   }
                              // }
                            },
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
                          onPressed: () async {
                            print(textCodeController);
                            if (_formKey.currentState!.validate()) {
                              future = await (getRoomByCode(code.toString()));
                              if (future == null) {
                                final snackBar = SnackBar(
                                  content: const Text('รหัสไม่ถูกต้อง'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                roomWithOwnerUser = future;
                                print(widget.info!.id.toString() +
                                    roomWithOwnerUser[0].id.toString());
                                await createParticipate(
                                    widget.info!.id, roomWithOwnerUser[0].id);
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        settings: const RouteSettings(
                                            name: '/roompage'),
                                        builder: (context) => new RoomPage(
                                              roomModel: roomWithOwnerUser[0],
                                              ownerModel: roomWithOwnerUser[0]
                                                  .ownerModel,
                                            )));
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

  // ignore: non_constant_identifier_name
}
