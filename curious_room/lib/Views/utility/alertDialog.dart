import 'package:flutter/material.dart';

Future<dynamic> confirmDialog(BuildContext context, String message) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'คุณแน่ใจนะ?',
              style: TextStyle(color: Color.fromRGBO(246, 127, 123, 1.0)),
            ),
            content: Text('$message'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'false'),
                child: const Text(
                  'ยกเลิก',
                  style: TextStyle(color: Color.fromRGBO(246, 127, 123, 1.0)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'true'),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(color: Color.fromRGBO(69, 171, 157, 1.0)),
                ),
              ),
            ],
            elevation: 24.0,
          ));
}
