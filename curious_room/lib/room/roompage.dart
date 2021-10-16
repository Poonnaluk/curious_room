import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String projectName;
  const RoomPage({Key? key, required this.projectName}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
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
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text(
            widget.projectName,
          ),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 28, fontFamily: 'Prompt'),
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
      );
    }
  }
}
