import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  final String current_id;
  final String contact_id;

  MessageField(this.current_id, this.contact_id);

  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  TextEditingController _controller = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Enter message...",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.current_id)
                  .collection('conversations')
                  .doc(widget.contact_id)
                  .collection('messages')
                  .add({
                "sender_id": widget.current_id,
                "receiver_id": widget.contact_id,
                "message": message,
                "datetime": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.current_id)
                    .collection('conversations')
                    .doc(widget.contact_id)
                    .set({
                  "last_message": message,
                });
              });
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.contact_id)
                  .collection('conversations')
                  .doc(widget.current_id)
                  .collection('messages')
                  .add({
                "sender_id": widget.current_id,
                "receiver_id": widget.contact_id,
                "message": message,
                "datetime": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.contact_id)
                    .collection('conversations')
                    .doc(widget.current_id)
                    .set({
                  "last_message": message,
                });
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
