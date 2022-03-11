import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_field.dart';
import 'message.dart';

class ChatScreen extends StatelessWidget {
  final String contact_id;
  final String contact_name;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ChatScreen({
    required this.contact_id,
    required this.contact_name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          contact_name,
          style: TextStyle(fontSize: 20),
        )),
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
                    .doc(contact_id)
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
            MessageField(firebaseAuth.currentUser!.uid, contact_id),
          ],
        ));
  }
}
