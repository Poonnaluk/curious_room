import 'dart:io';
import 'package:curious_room/Models/PostModel.dart';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/room/roompage.dart';
import 'package:curious_room/Views/utility/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePost extends StatefulWidget {
  final UserModel userModel;
  final RoomModel roomModel;
  final UserModel ownerModel;
  CreatePost(
      {Key? key,
      required this.userModel,
      required this.roomModel,
      required this.ownerModel})
      : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // ignore: unused_field
  // final _formKey = new GlobalKey<FormState>();
  String content = "";
  TextEditingController contentController = TextEditingController();
  bool isTextFiledFocus = false;
  late double screenw;
  late double screenh;
  File? image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: screenh * 0.085,
        title: Text('สร้างคำถาม'),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(107, 103, 98, 1),
            fontSize: 20.5.sp,
            fontFamily: 'Prompt'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            print(contentController.value.text.isEmpty);
            if (image == null && contentController.value.text.isEmpty) {
              Navigator.pop(context);
            } else {
              confirmDialog(context, 'คุณต้องการละทิ้งการสร้างคำถามนี้').then(
                  (value) => value == 'true' ? Navigator.pop(context) : null);
            }
          },
          color: Color.fromRGBO(107, 103, 98, 1),
          iconSize: 50,
        ),
        actions: <Widget>[
          _buildButtonCreate(),
          SizedBox(
            width: screenw * 0.015,
          )
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.4,
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                            backgroundImage: widget
                                        .userModel.display.runtimeType
                                        .toString() ==
                                    "_File"
                                ? Image.file(widget.userModel.display).image
                                : Image.network(
                                        widget.userModel.display.toString())
                                    .image,
                            radius: 17,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: Text(
                            widget.userModel.name,
                            style: TextStyle(
                                color: Color.fromRGBO(107, 103, 98, 1),
                                fontSize: 20.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Focus(
                          onFocusChange: (value) {
                            setState(() {
                              isTextFiledFocus = value;
                            });
                          },
                          child: inputField(contentController))),
                  // ignore: unnecessary_null_comparison
                  image != null
                      ? Stack(children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Image.file(
                                image!,
                                width: 100.w,
                                height: 25.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton.icon(
                                icon: Image.asset(
                                  'assets/icons/image.png',
                                  scale: 16,
                                ),
                                label: Text(
                                  'เปลี่ยนรูปภาพ',
                                  style: TextStyle(
                                      color: Color.fromRGBO(176, 162, 148, 1)),
                                ),
                                onPressed: () => chooseImage(),
                              ),
                            ),
                          ]),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () => setState(() {
                                      image = null;
                                    }),
                                icon: Icon(
                                  Icons.clear,
                                  color: Color.fromRGBO(124, 124, 124, 80),
                                )),
                          ),
                        ])
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 1,
                                color: Color.fromRGBO(176, 162, 148, 1),
                              ),
                            ),
                            TextButton(
                              onPressed: () => chooseImage(),
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                      'assets/icons/image.png',
                                      scale: 11,
                                    ),
                                  ),
                                  Text(
                                    'เพิ่มรูปภาพ',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(176, 162, 148, 1)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => content = value.trim(),
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 9,
      style: TextStyle(fontSize: 19.sp),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'คุณกำลังสงสัยอะไรอยู่...',
        errorStyle: TextStyle(
          color: Colors.red[400],
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.all(15.0),
      ),
    );
  }



  Future chooseImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget _buildButtonCreate() {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: isTextFiledFocus || image != null
                ? Color.fromRGBO(69, 171, 157, 1)
                : Color.fromRGBO(237, 237, 237, 1),
            padding: const EdgeInsets.all(10.0),
            primary: Colors.white,
            textStyle: TextStyle(fontSize: 17.sp, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () async {
          print(image);
          if (content == "" && image == null) {
            final snackBar = SnackBar(
              content: const Text('กรุณาเพิ่มเนื้อหา'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            setState(() {
              isLoading = true;
            });

            await creatPost(
                widget.userModel.id, widget.roomModel.id, content, image);

            setState(() {
              isLoading = false;
            });

            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                settings: const RouteSettings(name: '/roompage'),
                builder: (context) => new RoomPage(
                      userModel: widget.userModel,
                      roomModel: widget.roomModel,
                      ownerModel: widget.ownerModel,
                    )));
          }
        },
        child: Text(
          'โพสต์',
          style: TextStyle(
            color: isTextFiledFocus || image != null
                ? Colors.white
                : Color.fromRGBO(107, 103, 98, 1),
          ),
        ),
      ),
    );
  }
}