//   import 'package:flutter/material.dart';

// dynamic _buildDialog(BuildContext context) {
//     return showGeneralDialog(
//       barrierDismissible: true,
//       transitionDuration: Duration(milliseconds: 500),
//       barrierLabel: "",
//       context: context,
//       pageBuilder: (context, a1, a2) {
//         return Dialog(
//             insetPadding: owner
//                 ? EdgeInsets.only(top: screenh * 0.745)
//                 : EdgeInsets.only(top: screenh * 0.83),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   owner
//                       ? InkWell(
//                           child: _buildSelections(
//                               iconAsset: 'assets/icons/edit_icon.png',
//                               name: "แก้ไขชื่อห้อง"),
//                           onTap: () async {
//                             showDialog(
//                                 context: context,
//                                 builder: (_) => EditRoom(
//                                       roomname: widget.roomModel.name,
//                                       roomid: widget.roomModel.id,
//                                     )).then((value) {
//                               if (value != null) {
//                                 print('room name >> $value');
//                                 setState(() {
//                                   roomName = value.toString();
//                                 });
//                                 Navigator.pop(context);
//                               }
//                             });
//                           },
//                         )
//                       : SizedBox(
//                           height: 0.0,
//                         ),
//                   InkWell(
//                     child: _buildSelections(
//                         iconAsset: 'assets/icons/delete_user_icon.png',
//                         name: "ลบสมาชิก"),
//                     onTap: () {
//                       Navigator.of(context)
//                           .push(new MaterialPageRoute(
//                               builder: (context) => new DeleteParticipate(
//                                   roomid: widget.roomModel.id)))
//                           .then((onGoBack));
//                     },
//                   ),
//                   InkWell(
//                     child: _buildSelections(
//                         iconAsset: 'assets/icons/delete_icon.png',
//                         name: "ลบห้อง"),
//                     onTap: () {
//                       confirmDialog(context,
//                               'หากคุณลบห้อง ข้อมูลโพสต์ คะแนนโหวต สมาชิกและสถิตของห้องนี้จะหายไป')
//                           .then((data) async {
//                         print('value >> $data');
//                         if (data == 'true') {
//                           await roomController.deleteRoom(widget.roomModel.id);
//                           await successDialog(context, 'ลบห้องสำเร็จ');
//                           Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                   builder: (context) => FirstPage()),
//                               (Route<dynamic> route) => false);
//                         }
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ));
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position:
//               Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
//           child: child,
//         );
//       },
//     );
//   }