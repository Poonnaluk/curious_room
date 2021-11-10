import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/controllers/roomController.dart';
import 'package:curious_room/Views/room/roompage.dart';
import 'package:flutter/material.dart';

class CreatRoomPage extends StatefulWidget {
  final UserModel userModel;
  CreatRoomPage({Key? key, required this.userModel}) : super(key: key);

  @override
  _CreatRoomPageState createState() => _CreatRoomPageState();
}

class _CreatRoomPageState extends State<CreatRoomPage> {
  final _formKey = new GlobalKey<FormState>();
  late String name;
  late String message;
  TextEditingController nameController = TextEditingController();
  RoomController roomController = RoomController();

  bool isTextFiledFocus = false;

  late double screenw;
  late double screenh;
  bool isLoading = false;

  Widget inputField(TextEditingController controller) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : TextFormField(
            onChanged: (value) {
              name = value.trim();
              setState(() {
                if (name.isNotEmpty) {
                  isTextFiledFocus = true;
                } else {
                  isTextFiledFocus = false;
                }
              });
            },
            controller: controller,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.red[400],
                  fontSize: 16,
                ),
                contentPadding: EdgeInsets.all(16.0),
                filled: true,
                fillColor: Colors.white,
                labelText: 'ชื่อห้องของคุณ...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0))),
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
      padding: EdgeInsets.all(5.0),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(16.0),
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            await roomController.addRoom(name, widget.userModel.id);
            setState(() {
              isLoading = true;
            });
            print(roomController.roomModel.ownerModel.name);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                  content: Text(
                    'สร้างห้องสำเร็จ',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Prompt',
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
            );
            print("project name = " +
                roomController.roomModel.name +
                " userid = " +
                roomController.roomModel.userId.toString());
            print("code = " +
                roomController.roomModel.code +
                " roomid = " +
                roomController.roomModel.id.toString());
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                settings: const RouteSettings(name: '/roompage'),
                builder: (context) => new RoomPage(
                      userModel: widget.userModel,
                      roomModel: roomController.roomModel,
                      ownerModel: roomController.roomModel.ownerModel,
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
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: screenh * 0.08,
          title: new Text('สร้างห้อง'),
          titleTextStyle: const TextStyle(
              color: Color.fromRGBO(124, 124, 124, 1),
              fontSize: 24,
              fontFamily: 'Prompt'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(124, 124, 124, 1),
            iconSize: 50,
          ),
          actions: <Widget>[
            _buildButtonCreate(),
            SizedBox(
              width: screenw * 0.005,
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(40, 200, 40, 0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[inputField(nameController)]))),
      );
    }
  }
}
