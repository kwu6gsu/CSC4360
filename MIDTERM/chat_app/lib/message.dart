import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final bool myMessage;

  Message({required this.message, required this.myMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
              color: myMessage ? Colors.black : Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Text(message, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
