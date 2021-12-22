import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasecrudoperation/pojo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController titleCon = TextEditingController();
  TextEditingController descCon = TextEditingController();
  var result;
  String selecteddata = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    setState(() {
                      selecteddata = result;
                      CollectionReference c =
                          FirebaseFirestore.instance.collection('UsersPost');
                      AddPost addpost =
                          AddPost(1, titleCon.text, descCon.text, selecteddata);
                      DateTime _now = DateTime.now();
                      Map<String, dynamic> data = <String, dynamic>{
                        "title": titleCon.text,
                        "description": descCon.text,
                        'id': 1,
                        'categories': selecteddata,
                        'time': _now,
                        'verified': true,
                      };
                      c
                          .add(data)
                          .then((value) => print('Post Added'))
                          .catchError((onError) => print(onError));
                    });
                  },
                )),
            Text(selecteddata),
          ],
        ),
      ),
    );
  }
}
