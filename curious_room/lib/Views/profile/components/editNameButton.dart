import 'package:flutter/material.dart';

class ButtonEditName extends StatelessWidget {
  const ButtonEditName(
      {Key? key,
      required this.updateProfileData,
      required this.isTextFiledFocus})
      : super(key: key);
  final dynamic updateProfileData;
  final bool isTextFiledFocus;
  @override
  Widget build(BuildContext context) {
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
}
