import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomeState createState() => HomeState();
}
class HomeState extends State<HomePage>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
          addPost();
        },
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: document['title'],
                subtitle: document['description'],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
Future addPost() async{
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Posts");
  Map<String, dynamic> data = <String, dynamic>{
    "title": "How to Dhaka",
    "description": "How to go Dhaka Desc",
  };
  collectionReference.doc().set(data).whenComplete(() => print('Post Added')).catchError((onError)=> print("Failed to add user: $onError"));
}
/*Future<void> addUser()async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUser = firebaseAuth.currentUser!.uid;
  String phoneNumber =firebaseAuth.currentUser!.phoneNumber.toString();
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Users");
  Map<String, dynamic> data = <String, dynamic>{
    "title": phoneNumber,
    "description": "description",
  };
  collectionReference.doc(currentUser).set(data).whenComplete(() => print('Added')).
  catchError((onError)=> print("Failed to add user: $onError"));
}*/
