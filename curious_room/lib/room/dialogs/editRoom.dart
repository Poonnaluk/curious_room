import 'package:curious_room/controllers/roomController.dart';
import 'package:flutter/material.dart';

class EditRoom extends StatefulWidget {
  final String roomname;
  final int roomid;

  EditRoom({Key? key, required this.roomname, required this.roomid})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => EditRoomState();
}

class EditRoomState extends State<EditRoom> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController textController = new TextEditingController();
  bool isTextFiledFocus = false;
  late String roomName;
  RoomController roomController = RoomController();

  late double screenw;
  late double screenh;

  @override
  void initState() {
    super.initState();
    textController.text = '${widget.roomname}';
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    {
      return Dialog(
          insetPadding:
              EdgeInsets.only(left: screenw * 0.02, right: screenw * 0.02),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            padding: EdgeInsets.all(25.0),
            height: 200.0,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      "เปลี่ยนชื่อห้อง",
                      style: textStyle(),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenh * 0.02,
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
                        child: new TextFormField(
                          controller: textController,
                          onChanged: (value) => roomName = value.trim(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buttonCancel(),
                    SizedBox(
                      width: screenw * 0.08,
                    ),
                    _buttonConfirm()
                  ],
                )
              ],
            ),
          ));
    }
  }

  Widget _buttonConfirm() {
    return InkWell(
      child: Text(
        "เปลี่ยนชื่อ",
        style: TextStyle(
            color: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            fontSize: 18),
      ),
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await roomController.updateRoomName(roomName, widget.roomid);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                content: Text(
                  'เปลี่ยนชื่อห้องสำเร็จ',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Prompt', fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          );
          late String name = roomController.roomModel.name;
          print('room name from dialog >> $name');
          Navigator.pop(context, name);
          print("dialog success.");
        }
      },
    );
  }

  Widget _buttonCancel() {
    return InkWell(
      child: Text(
        "ยกเลิก",
        style: textStyle(),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 18);
  }
}
