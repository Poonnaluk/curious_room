import 'package:curious_room/Views/profile/components/morebutton.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ButtonEditDisplay extends StatefulWidget {
  const ButtonEditDisplay({Key? key}) : super(key: key);

  @override
  State<ButtonEditDisplay> createState() => _ButtonEditDisplayState();
}

class _ButtonEditDisplayState extends State<ButtonEditDisplay> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20.h,
        width: 20.w,
        margin: EdgeInsets.only(left: 80, top: 80),
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
            color: Colors.black,
            iconSize: 16,
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              moreBotton(context);
            }));
  }
}
