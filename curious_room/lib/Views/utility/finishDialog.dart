import 'package:flutter/material.dart';

Future<dynamic> successDialog(BuildContext context, String message) async {
  return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 30.0),
          title: Text(
            '$message',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Image.asset(
            'assets/images/success_image.png',
            height: 124.0,
            width: 124.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'true'),
              child: const Text(
                'ตกลง',
                style: TextStyle(
                    color: Color.fromRGBO(69, 171, 157, 1.0), fontSize: 18),
              ),
            ),
          ],
          elevation: 24.0,
        );
      });
}
