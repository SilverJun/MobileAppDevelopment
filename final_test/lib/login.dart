// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:finaltest/AppData.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void addUserToDB(String uid) async {
  await Firestore.instance.collection('users').document(uid).get().then((value) {
    if (!value.exists) {
      //print("need to append user");
      Firestore.instance.collection('users').document(uid).setData({'likes':[]});
    }
  });
}

class AnonymousSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () async {
          _signInAnonymously(context);
        },
        child: const Text('Sign in anonymously'),
      ),
    );
  }

  // Example code of how to sign in anonymously.
  void _signInAnonymously(BuildContext context) async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      appProfile.user = user;
      appProfile.loginType = LoginType.Anonymous;
      addUserToDB(user.uid);
      Navigator.popAndPushNamed(context, '/home');
    }
  }
}

class GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () async {
          _signInWithGoogle(context);
        },
        child: const Text('Sign in with Google'),
      ),
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    if (user != null) {
      appProfile.user = user;
      appProfile.loginType = LoginType.Google;
      addUserToDB(user.uid);
      Navigator.popAndPushNamed(context, '/home');
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 80.0),
                Column(
                  children: <Widget>[
                    Image.asset('assets/diamond.png'),
                    SizedBox(height: 16.0),
                    Text('SHRINE'),
                  ],
                ),
                SizedBox(height: 120.0),
                // TODO: Wrap Username with AccentColorOverride (103)
                // TODO: Remove filled: true values (103)

                AnonymousSigninButton(),
                GoogleSigninButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// TODO: Add AccentColorOverride (103)
