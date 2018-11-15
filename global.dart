import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var notificationSelection;
var forumSelection;
//var forumKey;


GoogleSignIn googleSignIn;
FirebaseAuth firebaseAuth;
DatabaseReference dbRef;
StorageReference storageRef;
String userID;
Map roles;

void firebaseInit() {
  var firebaseApp = FirebaseApp.instance;
  googleSignIn = GoogleSignIn(scopes: ['email']);
  firebaseAuth = FirebaseAuth.instance;
  dbRef = FirebaseDatabase(app: firebaseApp).reference();
  storageRef =
      FirebaseStorage(app:firebaseApp, storageBucket:'gs://reach-e3652.appspot.com').ref();
  Fluttertoast.showToast(msg: 'Initialization is done');
}


Future<bool> signIn(context) async {
  var account = await googleSignIn.signIn();
  if (account != null && account.email.endsWith('hkbu.edu.hk')) {
    var googleAuth = await account.authentication;
    var user = await firebaseAuth.signInWithGoogle(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );
    userID = user.email.substring(0, user.email.indexOf('@'));
  } else {
    googleSignIn.signOut();
    userID = null;
    var alert = AlertDialog(
      title: Text('Sign in'),
      content: Text('Please sign in with your HKBU email account.'),
    );
    showDialog(context: context, builder: (_)=>alert);
  }
  return userID != null;
}

void signOut() async {
  userID = null;
  await firebaseAuth.signOut();
  await googleSignIn.signOut();
}

Future<void> getRoles() async {
  var rolesRef = dbRef.child('users/$userID/roles');
  var snapshot = await rolesRef.once();
  roles = snapshot.value as Map;
}

