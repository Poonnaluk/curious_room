import 'package:flutter/material.dart';

// Future<dynamic> confirmDialog(BuildContext context, String message) async {
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text('คุณแน่ใจนะ?'),
//           content: Text('$message'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text(
//                 'ยกเลิก',
//                 style: TextStyle(color: Color.fromRGBO(246, 127, 123, 1.0)),
//               ),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text(
//                 'ยืนยัน',
//                 style: TextStyle(color: Color.fromRGBO(69, 171, 157, 1.0)),
//               ),
//             ),
//           ],
//           elevation: 24.0,
//         );
//       });
// }

// class MyMenu extends StatelessWidget {
//   MyMenu({Key? key, required this.message}) : super(key: key);
//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('AlertDialog Title'),
//         content: const Text('AlertDialog description'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'OK'),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

Future<dynamic> confirmDialog(BuildContext context, String message) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('คุณแน่ใจนะ?'),
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
