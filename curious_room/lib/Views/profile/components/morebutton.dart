
import 'package:curious_room/Views/Style/screenStyle.dart';

import 'package:curious_room/Views/utility/openGallery.dart';
import 'package:curious_room/Views/utility/themeMoreButton.dart';
import 'package:flutter/material.dart';

moreBotton(BuildContext context) {

  return showGeneralDialog(
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
      barrierLabel: "",
      context: context,
      pageBuilder: (context, a1, a2) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.only(top: screenh(context, 0.912)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: 1, color: Color.fromRGBO(107, 103, 98, 1.0)),
                  TextButton(
                      onPressed: () async {
                        final imageTemporary = await chooseImage();
                        if (imageTemporary == null) {
                          Navigator.pop(context);
                        } else {
                          cropImage(context, imageTemporary);
                        }
                      },
                      child: themeMoreButton(
                          'assets/icons/image.png', 'เลือกรูปโปรไฟล์'))
                ],
              ),
            ),
          );
        });
      });
}
