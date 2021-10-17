import 'package:curious_room/room/roompage.dart';
import 'package:flutter/material.dart';

class CreatRoomPage extends StatefulWidget {
  const CreatRoomPage({Key? key}) : super(key: key);

  @override
  _CreatRoomPageState createState() => _CreatRoomPageState();
}

class _CreatRoomPageState extends State<CreatRoomPage> {
  final _formKey = new GlobalKey<FormState>();

  late String name;
  TextEditingController nameController = TextEditingController();

  bool isTextFiledFocus = false;

  late double screenw;
  late double screenh;

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => name = value.trim(),
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 26),
      decoration: InputDecoration(
        hintText: 'กรุณากรอกชื่อห้องของคุณ',
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'คุณยังไม่ได้กรอกชื่อห้อง';
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                  content: Text(
                    'สร้างห้องสำเร็จ',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Prompt',
                        fontSize: 26),
                    textAlign: TextAlign.center,
                  )),
            );
            print(name);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomPage(projectName: name)));
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
                    child: Container(
                      height: 68.0,
                      child: inputField(nameController),
                    ),
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

  // BoxDecoration boxInput() {
  //   return BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //             color: Color(0xFF000000), blurRadius: 4, offset: Offset(0.0, 1.0))
  //       ],
  //       borderRadius: BorderRadius.circular(20.0));
  // }
}
