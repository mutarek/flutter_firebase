import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singuplogin/ui/googlesign.dart';
import 'package:singuplogin/ui/home.dart';
import 'package:singuplogin/ui/phonesignup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Initializer(),
    );
  }
}

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  late FirebaseAuth firebaseAuth;
  late User _user;
  bool isloading = true;

  @override
  void initState() {
    firebaseAuth = FirebaseAuth.instance;
    _user = firebaseAuth.currentUser!;
    this.isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.isloading?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):_user.isAnonymous ? GoogleSign():HomePage();
  }
}
