import 'dart:io';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/Style/color.dart';
import 'package:curious_room/Views/profile/components/editDisplayButton.dart';
import 'package:curious_room/Views/profile/components/editNameButton.dart';
import 'package:curious_room/Views/utility/showImage.dart';
import 'package:curious_room/controllers/loginController.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Style/textStyle.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenw;
  late double screenh;
  UserModel? usermodel;

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

  dynamic updateProfileData() async {
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
            widget.userModel.name = username;
            context.read<UserProvider>().setUser(widget.userModel);
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
    usermodel = context.watch<UserProvider>().userModel;
    File? imgFile = context.watch<UserProvider>().file;
    String subname = username.substring(0, 8);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(246, 127, 123, 1),
        toolbarHeight: screenh * 0.058,
        leading: IconButton(
          alignment: Alignment.topLeft,
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
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
                color: pinkColor,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ImageScreen(uri: usermodel!.display);
                      }));
                      print("Image file >> $imgFile");
                      print("Image url >> ${widget.userModel.display}");
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                      radius: 60,
                      backgroundImage: imgFile == null
                          ? Image.network(widget.userModel.display).image
                          : Image.file(imgFile).image,
                      onBackgroundImageError: (exception, context) {
                        print('$imgFile Cannot be loaded');
                      },
                      child: ButtonEditDisplay(),
                    ),
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
                                ? ButtonEditName(
                                    updateProfileData: updateProfileData,
                                    isTextFiledFocus: isTextFiledFocus,
                                  )
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
                                Text('${listType[index]}',
                                    style: normalTextStyle(18)),
                              ],
                            ),
                            Row(children: [
                              Text('0', style: normalTextStyle(18))
                            ])
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
