import 'package:firebase_auth/firebase_auth.dart';

enum LoginType{None, Google, Anonymous}

class AppProfile {
  FirebaseUser user;
  LoginType loginType;

  AppProfile() {
    user = null;
    loginType = LoginType.None;
  }

}

AppProfile appProfile = AppProfile();

final String storagePath = 'gs://finaltest-f944a.appspot.com/';
bool isDescending = false;
