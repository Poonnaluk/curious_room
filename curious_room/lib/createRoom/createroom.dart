import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/room/roompage.dart';
import 'package:flutter/material.dart';

class CreatRoomPage extends StatefulWidget {
  const CreatRoomPage({Key? key}) : super(key: key);

  @override
  _CreatRoomPageState createState() => _CreatRoomPageState();
}

class _CreatRoomPageState extends State<CreatRoomPage> {
  final _formKey = new GlobalKey<FormState>();
  late Future<RoomModel> _futureRoom;

  late String name;
  late int userid = 1;
  late String message;
  TextEditingController nameController = TextEditingController();

  bool isTextFiledFocus = false;

  late double screenw;
  late double screenh;

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => name = value.trim(),
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.red[400],
            fontSize: 18,
          ),
          contentPadding: EdgeInsets.all(20.0),
          filled: true,
          fillColor: Colors.white,
          labelText: 'ชื่อห้องของคุณ...',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อห้อง';
        }
        return null;
      },
    );
  }

  Widget _buildButtonCreate() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(16.0),
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 22, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _futureRoom = createRoom(name, userid);
              _futureRoom.then((value) {
                name = value.name;
                userid = value.userId;
              });
              print("project name=" + name + "userid=" + userid.toString());
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                  content: Text(
                    'สร้างห่องสำเร็จ',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Prompt',
                        fontSize: 26),
                    textAlign: TextAlign.center,
                  )),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomPage(
                          projectName: name,
                          userid: userid,
                        )));
          }
        },
        child: const Text('สร้างห้อง'),
      ),
    );
  }

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
          title: new Text('สร้างห้อง'),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontFamily: 'Prompt'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
            iconSize: 50,
          ),
          actions: <Widget>[
            _buildButtonCreate(),
            SizedBox(
              width: screenw * 0.015,
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(100, 200, 100, 0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Focus(
                    child: inputField(nameController),
                    onFocusChange: (hasvalue) {
                      setState(() {
                        isTextFiledFocus = hasvalue;
                      });
                    },
                  )
                ]))),
      );
    }
  }
}
