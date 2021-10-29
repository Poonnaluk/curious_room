import 'dart:io';
import 'package:curious_room/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePost extends StatefulWidget {
  final UserModel userModel;
  CreatePost({Key? key, required this.userModel}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = new GlobalKey<FormState>();
  late String name;
  TextEditingController contentController = TextEditingController();
  bool isTextFiledFocus = false;
  late double screenw;
  late double screenh;
  File? image;
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
          onPressed: () => Navigator.pop(context),
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
        child: Column(
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
                      backgroundImage:
                          Image.network(widget.userModel.display).image,
                      radius: 17,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
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
            if (image == null)
              SizedBox()
            else
              Expanded(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.file(
                      image!,
                      width: 10.w,
                      height: 10.h,
                    )),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 1,
                color: Color.fromRGBO(176, 162, 148, 1),
              ),
            ),
            TextButton(
              onPressed: () => chooseImage(ImageSource.gallery, image!),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(
                      'assets/icons/image.png',
                      scale: 11,
                    ),
                  ),
                  Text(
                    'เพิ่มรูปภาพ',
                    style: TextStyle(color: Color.fromRGBO(176, 162, 148, 1)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller) {
    return TextFormField(
      onChanged: (value) => name = value.trim(),
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
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: !isTextFiledFocus
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(10.0),
            primary: Colors.white,
            textStyle: TextStyle(fontSize: 17.sp, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Color.fromRGBO(119, 192, 182, 1),
                  content: Text(
                    'สร้างคำถามสำเร็จ',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Prompt',
                        fontSize: 26.sp),
                    textAlign: TextAlign.center,
                  )),
            );
            print(name);
          }
        },
        child: Text(
          'โพสต์',
          style: TextStyle(
            color: !isTextFiledFocus
                ? Color.fromRGBO(107, 103, 98, 1)
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource, File file) async {
    try {
      var object = await ImagePicker().pickImage(
          source: imageSource, maxHeight: 480, maxWidth: 640, imageQuality: 50);
      setState(() {
        file = object as File;
      });
    } catch (e) {}
  }
  // getUsers() async {
  //   final response = await http.post(
  //       Uri.parse('http://192.168.43.94:8000/user/610107030011@dpu.ac.th'));
  //   print(response.body);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUsers();
  // }
}
