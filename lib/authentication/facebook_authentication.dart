import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
class FacebookAuthService {


  static Future signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();


  if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!;
      final credetional = FacebookAuthProvider.credential(
        accessToken.token,
      );

      return credetional;
    } else {
      print(result.status);
      print(result.message);
    }
  }
}