import 'package:flutter/material.dart';

class AboutRoomPage extends StatefulWidget {
  final int roomid;
  final String roomName;
  final String code;
  final int userid;
  AboutRoomPage(
      {Key? key,
      required this.roomid,
      required this.roomName,
      required this.code,
      required this.userid})
      : super(key: key);

  @override
  _AboutRoomPageState createState() => _AboutRoomPageState();
}

class _AboutRoomPageState extends State<AboutRoomPage> {
// resposive
  late double screenw;
  late double screenh;

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
                    height: screenh * 0.02,
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
                            fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.008,
                  ),
                  Container(
                    height: 1,
                    color: Color.fromRGBO(69, 171, 157, 1.0),
                  ),
                ],
              )),
        )),
      );
    }
  }
}
