// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:curious_room/firstpage.dart';
import 'package:curious_room/room/roompage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/loginController.dart';

import 'Models/RoomModel.dart';

void main() {
  runApp(Login());
}

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  late UserModel userModel;
  late RoomModel roomModel;
  late UserModel ownerModel;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext, Orientation, ScreenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginPage(),
          theme: ThemeData(fontFamily: 'Prompt'),
          initialRoute: '/',
          routes: {
            '/firstpage': (context) => FirstPage(
                  info: userModel,
                ),
            '/roompage': (context) => RoomPage(
                userModel: userModel,
                roomModel: roomModel,
                ownerModel: ownerModel),
          },
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenw;
  late double screenh;
  late String email;
  late String name;
  // late UserModel _user;
  late dynamic user;
  // late UserModel _regisToGbase;
  final controller = Get.put(LoginController());
  late UserModel Info;
  // @override
  // void initState() {
  //   super.initState();
  //   print(controller.googleAccount.value);

  //   if (controller.googleAccount.value != null) {
  //     check(controller.googleAccount.value!.email);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => FirstPage(
  //           info: Info,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    print('$screenh ,$screenw');

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BG.png"), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                margin: EdgeInsets.fromLTRB(screenw * 0.015, screenh * 0.09,
                    screenw * 0.015, screenh * 0.09),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                margin: EdgeInsets.fromLTRB(screenw * 0.06, screenh * 0.04,
                    screenw * 0.06, screenh * 0.04),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      paddingLogo(0.25),
                      Text(
                        'C',
                        style: Style(246, 127, 123, 1),
                      ),
                      Text(
                        'U',
                        style: Style(235, 141, 63, 1),
                      ),
                      Text(
                        'R',
                        style: Style(69, 171, 157, 1),
                      ),
                      Text(
                        'I',
                        style: Style(233, 160, 151, 1),
                      ),
                      Text(
                        'O',
                        style: Style(235, 141, 63, 1),
                      ),
                      Text(
                        'U',
                        style: Style(246, 127, 123, 1),
                      ),
                      Text(
                        'S',
                        style: Style(69, 171, 157, 1),
                      ),
                      paddingLogo(0.25),
                    ],
                  ),
                  SizedBox(
                    height: screenh * 0.03,
                  ),
                  Text('R O O M',
                      style: TextStyle(
                          color: Color.fromRGBO(69, 171, 157, 1),
                          letterSpacing: 10,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Promptligth')),
                  SizedBox(
                    height: screenh * 0.25,
                  ),
                  googleButton()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container googleButton() {
    return Container(
      width: screenw * 0.7,
      height: screenh * 0.05,
      child: SignInButton(
        Buttons.Google,
        onPressed: () async {
          await controller.login();
          bool substring =
              controller.googleAccount.value!.email.contains("@dpu.ac.th");
          if (substring == true) {
            await check(controller.googleAccount.value!.email);
            if (user == null) {
              print('${controller.googleAccount.value?.photoUrl}');
              await createUser(
                  controller.googleAccount.value!.displayName.toString(),
                  controller.googleAccount.value!.email,
                  controller.googleAccount.value!.photoUrl.toString());
              await check(controller.googleAccount.value!.email);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(
                    info: Info,
                  ),
                ),
              );
            } else {
              print(Info.display);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(
                    info: Info,
                  ),
                ),
              );
              // }
            }
          } else {
            controller.signout();
            final snackBar = SnackBar(
              content: const Text('โปรดใช้อีเมลของ DPU '),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  TextStyle Style(int r, int g, int b, double o) {
    return TextStyle(
        color: Color.fromRGBO(r, g, b, o),
        fontSize: 21.sp,
        fontWeight: FontWeight.w300,
        fontFamily: 'Promptligth');
  }

  SizedBox paddingLogo(double w) {
    return SizedBox(
      width: screenw * w,
    );
  }

  Future<void> check(String email) async {
    user = (await regischeck(email));
    if (user != null) {
      Info = user;
    }
  }
}
