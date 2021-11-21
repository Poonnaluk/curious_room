import 'dart:io';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Models/UserStatsModel.dart';
import 'package:curious_room/Views/Style/color.dart';
import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/firstpage.dart';
import 'package:curious_room/Views/profile/components/editDisplayButton.dart';
import 'package:curious_room/Views/profile/components/editNameButton.dart';
import 'package:curious_room/Views/profile/components/listScore.dart';
import 'package:curious_room/Views/utility/showImage.dart';
import 'package:curious_room/controllers/loginController.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? userModel;
  final page;
  ProfilePage({Key? key, required this.userModel, this.page}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? usermodel;

  final _formKey = new GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  LoginController userController = LoginController();
  late String username;

  bool _clickChanged = false;
  bool isTextFiledFocus = false;
  bool _displayNameValid = true;
  File? img;

  late Future<UserStatsModel> future;

  @override
  void initState() {
    super.initState();
    nameController.text = '${widget.userModel!.name}';
    username = '${widget.userModel!.name}';
    future = getStats(widget.userModel!.id, widget.userModel!.role);
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
                      if (hasvalue != widget.userModel!.name) {
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
        if (nameController.text != widget.userModel!.name) {
          await userController.updateDisplayname(
              widget.userModel!.id, nameController.text, img);
          setState(() {
            username = nameController.text;
            widget.userModel!.name = username;
            context.read<UserProvider>().setUser(widget.userModel!);
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
    usermodel = context.watch<UserProvider>().userModel;
    String subname = username.substring(0, 8);
    checkRole(widget.userModel!);
    bool owner = checkOwner(widget.userModel!, usermodel);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(246, 127, 123, 1),
        toolbarHeight: screenh(context, 0.058),
        leading: IconButton(
          alignment: Alignment.topLeft,
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            widget.page == 'menubar'
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => FirstPage(),
                    ),
                  )
                : Navigator.pop(context);
          },
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
              height: screenh(context, 0.35),
              width: screenw(context, 1),
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
                        return ImageScreen(uri: widget.userModel!.display);
                      }));
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                      radius: 60,
                      backgroundImage: widget.userModel!.display.runtimeType
                                  .toString() ==
                              "_File"
                          ? Image.file(widget.userModel!.display).image
                          : Image.network(widget.userModel!.display.toString())
                              .image,
                      child: owner ? ButtonEditDisplay() : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    height: screenh(context, 0.02),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _clickChanged
                          ? buildDisplayNameField()
                          : Text(
                              owner ? '$subname...' : widget.userModel!.name,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                      owner
                          ? Column(
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
                          : SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: screenh(context, 0.01),
                  ),
                  owner
                      ? Text(
                          widget.userModel!.email,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(
              height: screenh(context, 0.02),
            ),
            listScore(future),
          ],
        )),
      )),
    );
  }
}
