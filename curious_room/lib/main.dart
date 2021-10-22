// ignore_for_file: unused_element

import 'dart:ui';

import 'package:curious_room/firstpage.dart';
import 'package:curious_room/room/roompage.dart';
import 'package:curious_room/login/loginController.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe, unused_import
import 'package:google_sign_in/google_sign_in.dart';
import 'package:curious_room/Models/UserModel.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(fontFamily: 'Prompt'),
      initialRoute: '/',
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/roompage': (context) =>
            RoomPage(roomid: 0, roomName: '', code: '', userid: 0),
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

  @override
  Widget build(BuildContext context) {
    screenw = MediaQuery.of(context).size.width;
    screenh = MediaQuery.of(context).size.height;
    print('$screenh ,$screenw');

    @override
    void initState() {
      super.initState();
      if (controller.googleAccount.value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
            (Route<dynamic> route) => false);
      }
    }

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
                          fontSize: 25,
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

          await check(controller.googleAccount.value!.email);
          if (user == null) {
            print('${controller.googleAccount.value?.photoUrl}');
            await createUser(
                controller.googleAccount.value!.displayName.toString(),
                controller.googleAccount.value!.email,
                controller.googleAccount.value!.photoUrl.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FirstPage()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => FirstPage()),
                (Route<dynamic> route) => false);
            // }
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  TextStyle Style(int r, int g, int b, double o) {
    return TextStyle(
        color: Color.fromRGBO(r, g, b, o),
        fontSize: 25,
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
  }
}
