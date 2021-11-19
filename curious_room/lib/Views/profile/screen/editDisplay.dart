import 'package:curious_room/Views/Style/screenStyle.dart';
import 'package:curious_room/Views/Style/textStyle.dart';
import 'package:curious_room/Views/profile/components/createButton.dart';
import 'package:curious_room/Views/utility/openGallery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditDisplayPage extends StatefulWidget {
  EditDisplayPage({Key? key, this.cropped}) : super(key: key);
  final cropped;

  @override
  _EditDisplayPageState createState() => _EditDisplayPageState();
}

class _EditDisplayPageState extends State<EditDisplayPage> {

  @override
  Widget build(BuildContext context) {
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
          buildEditPostButton(context, widget.cropped),
          SizedBox(
            width: screenw(context, 0.015),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            if (widget.cropped != null) ...[
              Image.file(widget.cropped),
              Transform.scale(
                scale: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                      onPressed: () => cropImage(context, widget.cropped),
                      icon: Icon(Icons.crop)),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
