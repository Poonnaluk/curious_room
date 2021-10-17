import 'package:curious_room/utility/utility.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late double screenw;
  late double screenh;

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    {
      return Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text('roomPage'),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontFamily: 'Prompt'),
          leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(), //,
            icon: Image.asset(
              'assets/images/menu2.png',
              fit: BoxFit.cover,
            ),
            iconSize: 50,
          ),
        ),
        drawer: MyMenu(),
      );
    }
  }
}
