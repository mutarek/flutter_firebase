import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecrudoperation/addpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('UsersPost').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              bool is_verified = document['verified'];
              Timestamp _now = document['time'];
              DateTime d = _now.toDate();
              return Card(
                elevation: 5,
                color: Colors.amber,
                child: Container(
                  child: Column(
                    children: [
                      Text(is_verified?'Approved':'Dispose'),
                      SizedBox(
                        height: 5,
                      ),
                      Text(document['title']),
                      Text(document['description']),
                      Text(document['categories']),
                      Text(d.day.toString()),
                    ],
                  ),
                ),
              );
              return Container(
                child: Center(child: Text(document['title'])),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder)=> AddPostPage()));
        },
      ),
    );
  }

  /*void addPost(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var titleCon = TextEditingController();
          var descCon = TextEditingController();
          var nameController = TextEditingController();
          var result;
          return Column(
            children: [
              TextField(
                controller: titleCon,
              ),
              TextField(
                controller: descCon,
              ),
              Text('1 + 2 + 4 = ?'),
              RadioListTile(
                  title: Text('Flutter'),
                  value: 'flutter',
                  groupValue: result,
                  onChanged: (value) {
                    setState(() {
                      result = value;
                    });
                  }),
              RadioListTile(
                  title: Text('Web'),
                  value: 'web',
                  groupValue: result,
                  onChanged: (value) {
                    setState(() {
                      result = value;
                    });
                  }),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text('Button'),
                    onPressed: () {
                      print(nameController.text);
                    },
                  )),
            ],
          );
        });
  }*/
}
