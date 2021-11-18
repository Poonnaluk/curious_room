import 'dart:io';
import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDisplayPage extends StatefulWidget {
  EditDisplayPage({Key? key}) : super(key: key);

  @override
  _EditDisplayPageState createState() => _EditDisplayPageState();
}

class _EditDisplayPageState extends State<EditDisplayPage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    _image = context.watch<UserProvider>().file;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: screenh(context, 0.08),
        title: Text('อัพโหลดรูปโปรไฟล์'),
        titleTextStyle: normalTextStyle(18),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(107, 103, 98, 1),
          iconSize: 50,
        ),
        actions: <Widget>[
          // buildEditPostButton(),
          SizedBox(
            width: screenw(context, 0.015),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            if (_image != null) ...[
              Image.file(_image!),
              // Row(
              //   children: <Widget>[
              //     IconButton(onPressed: _cropImage, icon: Icon(Icons.crop)),
              //     IconButton(onPressed: _clear, icon: Icon(Icons.refresh))
              //   ],
              // )
            ]
          ],
        ),
      ),
    );
  }
}
