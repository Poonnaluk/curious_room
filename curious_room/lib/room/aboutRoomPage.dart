import 'package:curious_room/Models/ParticipateModel.dart';
import 'package:curious_room/controllers/roomController.dart';
import 'package:flutter/material.dart';

class AboutRoomPage extends StatefulWidget {
  final int roomid;
  final String roomName;
  final String code;
  final int ownerid;
  final String ownerName;
  final String ownerDisplay;
  AboutRoomPage({
    Key? key,
    required this.roomid,
    required this.code,
    required this.ownerid,
    required this.roomName,
    required this.ownerName,
    required this.ownerDisplay,
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

  @override
  void initState() {
    super.initState();
    future = getParticipate(widget.roomid);
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text('เกี่ยวกับ'),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 24, fontFamily: 'Prompt'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(0, 0, 0, 25),
            iconSize: 50,
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.push();
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
            child: Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
              child: Column(
                children: [
                  SizedBox(
                    height: screenh * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.roomName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(69, 171, 157, 1.0),
                            fontSize: 22),
                      ),
                      Text(
                        widget.code,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(176, 162, 148, 1.0),
                            fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.015,
                  ),
                  Row(
                    children: [
                      Text(
                        "สมาชิก",
                        style: TextStyle(
                            color: Color.fromRGBO(225, 141, 63, 1.0),
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "เจ้าของ",
                        style: TextStyle(
                            color: Color.fromRGBO(69, 171, 157, 1.0),
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    height: 1.5,
                    color: Color.fromRGBO(69, 171, 157, 1.0),
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                        backgroundImage:
                            Image.network(widget.ownerDisplay.toString()).image,
                        radius: 15,
                      ),
                      SizedBox(
                        width: screenw * 0.01,
                      ),
                      Text(
                        widget.ownerName,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        "เพื่อนร่วมห้อง",
                        style: TextStyle(
                            color: Color.fromRGBO(69, 171, 157, 1.0),
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    height: 1.5,
                    color: Color.fromRGBO(69, 171, 157, 1.0),
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    child: Expanded(
                        child: FutureBuilder<List<ParticipateModel>>(
                            future: future,
                            builder: (context, snapshot) {
                              if (snapshot.data.toString() == "[]") {
                                return Text(
                                  'ยังไม่มีสมาชิก',
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(176, 162, 148, 1.0)),
                                );
                              } else if (snapshot.hasData) {
                                value = snapshot.data;
                                print(value);
                                return ListView.builder(
                                    itemCount: value!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              Color.fromRGBO(255, 255, 255, 0),
                                          backgroundImage: Image.network(
                                                  value?[index]
                                                      .userParticipate
                                                      ?.display)
                                              .image,
                                          radius: 15,
                                        ),
                                        title: Text((value?[index]
                                                .userParticipate
                                                ?.name)
                                            .toString()),
                                      );
                                    });
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            })),
                  ),
                ],
              )),
        )),
      );
    }
  }
}
