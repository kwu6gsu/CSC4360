import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'signup.dart';

class Home extends StatefulWidget {
  Home({this.uid});
  final String? uid;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String codeDialog;
  late String valueText;
  TextEditingController _textFieldController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Future<void> addMessage() {
    return messageCollection.add({
      'uid': firebaseAuth.currentUser!.uid,
      'context': _textFieldController.text,
      'datetime': firebaseAuth.currentUser!.metadata.creationTime
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Message"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('POST'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                  addMessage();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((res) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                    (Route<dynamic> route) => false);
              });
            },
          )
        ],
      ),
      body: Center(
        child: TextButton(
          child: Text("+"),
          onPressed: () {
            _displayTextInputDialog(context);
          },
        ),
      ),
    );
  }
}
