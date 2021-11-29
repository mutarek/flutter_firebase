import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:singuplogin/common/customtoast.dart';

class SignUp extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<SignUp> {
  bool isLoading = false;
  Future future(String semail, String spass) async {
    try {
      this.isLoading =true;
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: semail, password: spass);
      toast("Success Account Created");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.isLoading =false;
        toast("The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        this.isLoading =false;
        toast("The account already exists for that email");
      }
    } catch (e) {
      this.isLoading =false;
      toast(e.toString());
    }
  }

  TextEditingController emailCOntroler = TextEditingController();
  TextEditingController passControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: emailCOntroler,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: passControler,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => future(emailCOntroler.text, passControler.text),
            child: Text('SignUp'),
          )
        ],
      ),
    );
  }
}
