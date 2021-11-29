import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singuplogin/common/customtoast.dart';

class HomePage extends StatefulWidget {
  HomeState createState() => HomeState();
}
class HomeState extends State<HomePage>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          addUser();
        },
      ),
      body:  FutureBuilder<DocumentSnapshot>(
        future: users.doc("XW2ln61TmNcmjrJNtvt7").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          }

          return Text("loading");
        },
      ),
    );
  }
}
Future<void> addUser() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  return users
      .add({
    'full_name': "Mohiuddin Tarek", // John Doe
    'company': "Bangladesh Travel", // Stokes and Sons
    'age': 21 // 42
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
