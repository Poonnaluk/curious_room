import 'dart:io';

import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/controllers/loginController.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenw;
  late double screenh;

  final _formKey = new GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  LoginController userController = LoginController();
  late String username;
  var listIcon = [
    'Q_Icon.png',
    'A_Icon.png',
    'correct_icon.png',
    'score_icon.png'
  ];
  var listType = ['ถาม', 'ตอบ', 'คำตอบที่ดีที่สุด', 'คะแนนที่ได้รับ'];
  // var listIcon_admin = [
  //   'declare_Icon.png'
  // ];
  // var listType_admin = ['ประกาศ'];
  bool _clickChanged = false;
  bool isTextFiledFocus = false;
  bool _displayNameValid = true;
  File? img;

  @override
  void initState() {
    super.initState();
    nameController.text = '${widget.userModel.name}';
    username = '${widget.userModel.name}';
  }

  Widget buildDisplayNameField() {
    return Flexible(
        child: SizedBox(
            width: 150,
            child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: nameController,
                  onChanged: (hasvalue) {
                    setState(() {
                      if (hasvalue != widget.userModel.name) {
                        isTextFiledFocus = true;
                      } else {
                        isTextFiledFocus = false;
                      }
                    });
                  },
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    labelText: _displayNameValid ? '' : 'ชื่อสั้นเกินไป',
                    labelStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ))));
  }

  Widget _buildButtonCreate() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 0.1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(8.0),
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 12, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: updateProfileData,
        child: isTextFiledFocus ? Text('บันทึก') : Text('ยกเลิก'),
      ),
    );
  }

  updateProfileData() async {
    setState(() {
      nameController.text.trim().length < 8 || nameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      print(_displayNameValid);
    });

    if (_displayNameValid) {
      if (_formKey.currentState!.validate()) {
        _clickChanged = false;
        if (nameController.text != widget.userModel.name) {
          await userController.updateDisplayname(
              widget.userModel.id, nameController.text, img);
          setState(() {
            username = nameController.text;
            isTextFiledFocus = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                content: Text(
                  'เปลี่ยนชื่อสำเร็จ',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Prompt', fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;

    String image = widget.userModel.display.toString();
    String subname = username.substring(0, 8);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(246, 127, 123, 1),
        toolbarHeight: screenh * 0.058,
        leading: IconButton(
          alignment: Alignment.topLeft,
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, username),
          color: Color.fromRGBO(255, 255, 255, 0.8),
          iconSize: 50,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              height: screenh * 0.38,
              width: screenw * 1,
              decoration: BoxDecoration(
                color: Color.fromRGBO(246, 127, 123, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                    radius: 60,
                    backgroundImage: image == "null"
                        ? Image.asset('assets/images/logoIcon.png').image
                        : Image.network(image).image,
                    onBackgroundImageError: (exception, context) {
                      print('$image Cannot be loaded');
                    },
                    child: _buildEditImage(),
                  ),
                  SizedBox(
                    height: screenh * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _clickChanged
                          ? buildDisplayNameField()
                          : Text(
                              '$subname...',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _clickChanged
                                ? _buildButtonCreate()
                                : IconButton(
                                    color: Colors.black,
                                    icon: Image(
                                        image: Image.asset(
                                                'assets/icons/edit 1.png')
                                            .image),
                                    onPressed: () {
                                      setState(() {
                                        _clickChanged = true;
                                      });
                                    },
                                  )
                          ])
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.01,
                  ),
                  Text(
                    widget.userModel.email,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenh * 0.02,
            ),
            ListView.builder(
                padding: EdgeInsets.only(left: 20, top: 20, right: 30),
                shrinkWrap: true,
                itemCount: listType.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image(
                                    image: Image.asset(
                                            'assets/icons/${listIcon[index]}')
                                        .image),
                                SizedBox(
                                  width: screenw * 0.04,
                                ),
                                Text('${listType[index]}', style: textStyle()),
                              ],
                            ),
                            Row(children: [Text('0', style: textStyle())])
                          ],
                        ),
                        SizedBox(
                          height: screenh * 0.01,
                        ),
                        Container(
                          height: 1.5,
                          width: screenw * 0.80,
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                        ),
                        SizedBox(
                          height: screenh * 0.02,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        )),
      )),
    );
  }
}

TextStyle textStyle() {
  return TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 18);
}

Widget _buildEditImage() {
  return Container(
    height: 30,
    width: 30,
    margin: EdgeInsets.only(left: 80, top: 80),
    alignment: Alignment.bottomRight,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: IconButton(
      color: Colors.black,
      iconSize: 15,
      icon: Icon(Icons.photo_camera),
      onPressed: () {},
    ),
  );
}
