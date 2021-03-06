// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:curious_room/Views/firstpage.dart';
import 'package:curious_room/Views/room/roompage.dart';
import 'package:curious_room/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:curious_room/Models/UserModel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Views/room/roompage.dart';
import 'controllers/loginController.dart';

import 'Models/RoomModel.dart';

void main() {
  Intl.defaultLocale = "th";
  initializeDateFormatting();
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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResponsiveSizer(builder: (BuildContext, Orientation, ScreenType) {
          return LoginPage();
        }),
        theme: ThemeData(fontFamily: 'Prompt'),
        initialRoute: '/',
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/roompage': (context) => RoomPage(
              userModel: userModel,
              roomModel: roomModel,
              ownerModel: ownerModel)
        },
      ),
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
  bool isLoading = false;

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
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : googleButton()
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
          setState(() {
            isLoading = true;
          });
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
              setState(() {
                isLoading = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(),
                ),
              );
            } else {
              setState(() {
                isLoading = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FirstPage(),
                ),
              );
              // }
            }
          } else {
            controller.signout();
            setState(() {
              isLoading = false;
            });
            final snackBar = SnackBar(
              content: const Text('????????????????????????????????????????????? DPU '),
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
      context.read<UserProvider>().setUser(user);
    }
  }
}
