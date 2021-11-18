import 'package:curious_room/Models/UserModel.dart';
import 'package:curious_room/Views/profile/components/morebutton.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonEditDisplay extends StatefulWidget {
  const ButtonEditDisplay({Key? key}) : super(key: key);

  @override
  State<ButtonEditDisplay> createState() => _ButtonEditDisplayState();
}

class _ButtonEditDisplayState extends State<ButtonEditDisplay> {
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<UserProvider>().userModel;
    return Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: 80, top: 80),
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
            color: Colors.black,
            iconSize: 15,
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              moreBotton(context);
            }));
  }

  // //เปลี่ยน type string to file
  // Future<File?> urlToFile() async {
  //   // generate random number.
  //   var rng = new Random();
  //   // get temporary directory of device.
  //   Directory tempDir = await getTemporaryDirectory();
  //   // get temporary path from temporary directory.
  //   String tempPath = tempDir.path;
  //   // create a new file in temporary path with random file name.
  //   File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
  //   // call http.get method and pass imageUrl into it to get response.
  //   http.Response response = await http.get(Uri.parse(userModel!.display));
  //   await file.writeAsBytes(response.bodyBytes);
  //   _image = file;
  //   return _image;
  // }
}
