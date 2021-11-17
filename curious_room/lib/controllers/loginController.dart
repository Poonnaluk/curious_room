import 'package:curious_room/Models/UserModel.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  late UserModel userModel;

  login() async {
    googleAccount.value = await _googleSignin.signIn();
  }

  signout() async {
    await _googleSignin.disconnect();
  }

  updateDisplayname(int id, String name, dynamic img) async {
    await updateUserName(id, name, img);
  }
}
