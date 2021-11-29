import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singuplogin/common/customtoast.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<SignUp> {
  @override
  initState(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Common().toast('Welcome to Bangladesh Travel');
      } else {
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> HomePage()));
        Common().toast('User is signed in!');
      }
    });
    super.initState();
  }
  bool isLoading = false;
  Future future(String semail, String spass) async {
    try {
      this.isLoading =true;
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: semail, password: spass);
      Common().toast("Success Account Created");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.isLoading =false;
        Common().toast("The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        this.isLoading =false;
        Common(). toast("The account already exists for that email");
      }
    } catch (e) {
      this.isLoading =false;
      Common().toast(e.toString());
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
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: passControler,
              obscureText: true,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
              ),labelText: 'Password'),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if(emailCOntroler.text.isEmpty  || passControler.text.isEmpty){
                  Common().toast("Fields have to full fill");
                }
                else{
                  future(emailCOntroler.text,passControler.text);
                }
              },
              child: Text('SignUp'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
