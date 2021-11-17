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

// ignore: must_be_immutable
class EditPostPage extends StatefulWidget {
  EditPostPage({
    Key? key,
    required this.content,
    this.images,
    required this.postId,
    required this.userModel,
    required this.roomModel,
    required this.ownerModel,
  }) : super(key: key);
  int postId;
  UserModel userModel;
  String content;
  File? images;
  final RoomModel roomModel;
  final UserModel ownerModel;
  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late double screenw;
  late double screenh;
  String? content;
  String? beforeContent;
  bool isTextFiledFocus = false;
  bool isLoading = false;
  TextEditingController contentController = TextEditingController();
  File? image;
  File? beforeImage;

  @override
  void initState() {
    contentController.text = widget.content;
    content = widget.content;
    beforeContent = widget.content;
    image = widget.images;
    beforeImage = widget.images;
    super.initState();
  }

  @override
  void dispose() {
    image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    // if (widget.images.toString() != "null") {
    //   urlToFile(widget.images);
    //   image = _image;
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: screenh * 0.085,
        title: Text('แก้ไขโพสต์'),
        titleTextStyle: TextStyle(
            color: Color.fromRGBO(107, 103, 98, 1),
            fontSize: 20.5.sp,
            fontFamily: 'Prompt'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            if (image == beforeImage && content == beforeContent) {
              Navigator.pop(context);
            } else {
              confirmDialog(context, 'คุณต้องการละทิ้งการแก้ไขคำถามนี้').then(
                  (value) => value == 'true' ? Navigator.pop(context) : null);
            }
          },
          color: Color.fromRGBO(107, 103, 98, 1),
          iconSize: 50,
        ),
        actions: <Widget>[
          buildEditPostButton(),
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
                              backgroundImage:
                                  Image.network(widget.userModel.display).image,
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
                          ),
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
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : image != null
                            ? Stack(children: [
                                Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
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
                                                color: Color.fromRGBO(
                                                    176, 162, 148, 1)),
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
                                        color:
                                            Color.fromRGBO(124, 124, 124, 80),
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
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Image.asset(
                                            'assets/icons/image.png',
                                            scale: 11,
                                          ),
                                        ),
                                        Text(
                                          'เพิ่มรูปภาพ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  176, 162, 148, 1)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                  ],
                )),
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

  Container buildEditPostButton() {
    // bool isEdit = false;
    // if (!isTextFiledFocus || image != beforeImage) {
    //   setState(() {
    //     isEdit = true;
    //   });
    // } else {
    //   setState(() {
    //     isEdit = false;
    //   });
    // }
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: (!isTextFiledFocus && !(image != beforeImage))
                ? Color.fromRGBO(237, 237, 237, 1)
                : Color.fromRGBO(69, 171, 157, 1),
            padding: const EdgeInsets.all(10.0),
            primary: Colors.white,
            textStyle: TextStyle(fontSize: 17.sp, fontFamily: 'Prompt'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        onPressed: () async {
          // print(image);
          if (image == beforeImage && content == beforeContent) {
            final snackBar = SnackBar(
              content: const Text('ยังไม่มีการแก้ไขคำถาม'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            print(content);
            print("before content $beforeContent");
            print(image);
            print("beforeImage $beforeImage");
            print('post ID >> ${widget.postId}');
            setState(() {
              isLoading = true;
            });
            await editPost(widget.postId, content!, image);
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
              color: (!isTextFiledFocus && !(image != beforeImage))
                  ? Color.fromRGBO(107, 103, 98, 1)
                  : Colors.white),
        ),
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
}
