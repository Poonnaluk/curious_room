import 'package:curious_room/Models/ParticipateModel.dart';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Style/color.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/Views/profile/screen/profile.dart';
import 'package:curious_room/controllers/roomController.dart';
import 'package:curious_room/Views/utility/alertDialog.dart';
import 'package:curious_room/Views/utility/finishDialog.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../firstpage.dart';
import 'deleteParticipate.dart';
import 'dialogs/editRoom.dart';

class AboutRoomPage extends StatefulWidget {
  final RoomModel roomModel;
  final UserModel ownerModel;
  final UserModel userModel;
  AboutRoomPage({
    Key? key,
    required this.userModel,
    required this.roomModel,
    required this.ownerModel,
  }) : super(key: key);

  @override
  _AboutRoomPageState createState() => _AboutRoomPageState();
}

class _AboutRoomPageState extends State<AboutRoomPage> {
  RoomController roomController = RoomController();
  late Future<List<ParticipateModel>> future;
  late List<ParticipateModel>? value;
// resposive
  late double screenw;
  late double screenh;
  late bool userRole = false;
  late bool owner = false;
  late String roomName;

  @override
  void initState() {
    super.initState();
    refreshData();
    roomName = widget.roomModel.name;
  }

  void refreshData() {
    future = getParticipate(widget.roomModel.id);
  }

  Future onGoBack(dynamic value) async {
    refreshData();
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    String image = widget.ownerModel.display.toString();
    if (widget.userModel.id == widget.ownerModel.id ||
        widget.userModel.role == "ADMIN") {
      userRole = true;
    }
    if (widget.userModel.id == widget.ownerModel.id) {
      owner = true;
    }
    {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text('???????????????????????????'),
          titleTextStyle: const TextStyle(
              color: Color.fromRGBO(124, 124, 124, 1),
              fontSize: 24,
              fontFamily: 'Prompt'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context, roomName),
            color: grayColor,
            iconSize: 50,
          ),
          actions: [
            if (userRole)
              IconButton(
                onPressed: () async {
                  _buildDialog(context);
                },
                icon: Image.asset(
                  'assets/icons/more_icon.png',
                ),
                iconSize: 35,
              ),
            SizedBox(
              width: screenw * 0.005,
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: screenh * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          roomName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(69, 171, 157, 1.0),
                              fontSize: 21.sp),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '????????????????????????????????????',
                            textAlign: TextAlign.right,
                            style:
                                TextStyle(color: greenColor, fontSize: 16.sp),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            widget.roomModel.code,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color.fromRGBO(176, 162, 148, 1.0),
                                fontSize: 16.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.010,
                  ),
                  Row(
                    children: [
                      Text(
                        "??????????????????",
                        style: TextStyle(
                            color: Color.fromRGBO(225, 141, 63, 1.0),
                            fontSize: 19.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Row(
                    children: [
                      Text(
                        "?????????????????????",
                        style: greenTextStyle(18.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    height: 1.5,
                    color: greenColor,
                  ),
                  SizedBox(
                    height: screenh * 0.015,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenw * 0.04,
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                        radius: 15,
                        backgroundImage: image == "null"
                            ? Image.asset('assets/images/logoIcon.png').image
                            : Image.network(image).image,
                        onBackgroundImageError: (exception, context) {
                          print('$image Cannot be loaded');
                        },
                      ),
                      SizedBox(
                        width: screenw * 0.045,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userModel: (widget.ownerModel),
                                        page: 'about',
                                      )));
                        },
                        child: Text(
                          widget.ownerModel.name,
                          style: normalTextStyle(17.sp),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        "??????????????????????????????????????????",
                        style: greenTextStyle(18.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    height: 1.5,
                    color: greenColor,
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Transform.scale(
                    scale: 1,
                    child: getParticipates(context),
                  )
                ],
              )),
        )),
      );
    }
  }

  _buildDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              owner
                  ? InkWell(
                      child: _buildSelections(
                          iconAsset: 'assets/icons/edit_icon.png',
                          name: "???????????????????????????????????????"),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) => EditRoom(
                                  roomname: widget.roomModel.name,
                                  roomid: widget.roomModel.id,
                                )).then((value) {
                          if (value != null) {
                            print('room name >> $value');
                            setState(() {
                              roomName = value.toString();
                            });
                            Navigator.pop(context);
                          }
                        });
                      },
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              InkWell(
                child: _buildSelections(
                    iconAsset: 'assets/icons/delete_user_icon.png',
                    name: "????????????????????????"),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(
                          builder: (context) => new DeleteParticipate(
                              roomid: widget.roomModel.id)))
                      .then((onGoBack));
                },
              ),
              InkWell(
                child: _buildSelections(
                    iconAsset: 'assets/icons/delete_icon.png', name: "??????????????????"),
                onTap: () {
                  confirmDialog(context,
                          '???????????????????????????????????? ????????????????????????????????? ??????????????????????????? ??????????????????????????????????????????????????????????????????????????????????????????')
                      .then((data) async {
                    print('value >> $data');
                    if (data == 'true') {
                      await roomController.deleteRoom(widget.roomModel.id);
                      await successDialog(context, '????????????????????????????????????');
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => FirstPage()),
                          (Route<dynamic> route) => false);
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Widget _buildSelections({String? iconAsset, String? name}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 30),
              Image.asset(
                iconAsset.toString(),
                height: 30,
                width: 30,
              ),
              SizedBox(width: 20),
              Text(name.toString(),
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 20.sp)),
            ],
          ),
          SizedBox(height: 20),
          Container(height: 1, color: Color.fromRGBO(107, 103, 98, 1.0)),
        ]);
  }

  getParticipates(BuildContext context) {
    return FutureBuilder<List<ParticipateModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data == []) {
            return Text(
              '??????????????????????????????????????????',
              style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1.0)),
            );
          } else if (snapshot.hasData) {
            value = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: value!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                        backgroundImage: Image.network(
                                (value?[index].userParticipate?.display)
                                    .toString())
                            .image,
                        radius: 15,
                      ),
                      title: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userModel:
                                            (value?[index].userParticipate),
                                        page: 'about',
                                      )),
                            );
                          },
                          child: Text(
                              (value?[index].userParticipate?.name).toString(),
                              style: normalTextStyle(17.sp))));
                });
          }
          return Center(
              child: Column(children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 30,
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('?????????????????????????????????????????????...'),
            )
          ]));
        });
  }
}
