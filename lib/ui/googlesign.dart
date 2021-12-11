import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class GoogleSign extends StatefulWidget {
  @override
  _GoogleSignState createState() => _GoogleSignState();
}

class _GoogleSignState extends State<GoogleSign> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            height: 30,
            child: Card(
              elevation: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          signInWithGoogle().whenComplete(() {
                            addUser();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ),
                            );
                          });
                        },
                        child: Icon(Icons.ac_unit)),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

Future<void> addUser() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUser = firebaseAuth.currentUser!.uid;
  String phoneNumber = firebaseAuth.currentUser!.phoneNumber.toString();
  String email = firebaseAuth.currentUser!.email.toString();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("Users");
  Map<String, dynamic> data = <String, dynamic>{
    "phone": phoneNumber,
    "email": email,
    "uid": currentUser,
  };
  collectionReference
      .doc(currentUser)
      .set(data)
      .whenComplete(() => print('Added'))
      .catchError((onError) => print("Failed to add user: $onError"));
}
