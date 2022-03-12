import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_field.dart';
import 'message.dart';
import 'profile.dart';

class ChatScreen extends StatefulWidget {
  final String contact_id;
  final String contact_name;

  ChatScreen({
    required this.contact_id,
    required this.contact_name,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String codeDialog;
  late String valueText;
  TextEditingController _textFieldController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> rate() {
    return userCollection
        .doc(widget.contact_id)
        .collection('ratings')
        .doc(firebaseAuth.currentUser!.uid)
        .set({'score': int.parse(_textFieldController.text)});
  }

  Future<void> _displayRateDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rate This User From 0-5"),
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
                    _textFieldController.clear();
                  });
                },
              ),
              TextButton(
                child: Text('SUBMIT'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                  rate();
                  _textFieldController.clear();
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
            title: Text(
              widget.contact_name,
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.rate_review_outlined, color: Colors.white),
                  onPressed: () {
                    _displayRateDialog(context);
                  }),
              IconButton(
                  icon: Icon(Icons.account_box_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(uid: widget.contact_id)));
                  })
            ]),
        body: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebaseAuth.currentUser!.uid)
                    .collection('conversations')
                    .doc(widget.contact_id)
                    .collection('messages')
                    .orderBy('datetime', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("Start a conversation!"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool myMessage = snapshot.data.docs[index]
                                  ['sender_id'] ==
                              firebaseAuth.currentUser!.uid;
                          return Message(
                              message: snapshot.data.docs[index]['message'],
                              myMessage: myMessage);
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )),
            MessageField(firebaseAuth.currentUser!.uid, widget.contact_id),
          ],
        ));
  }
}
