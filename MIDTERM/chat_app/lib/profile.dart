import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  ProfileScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Name"),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Rating"),
            )
          ],
        )));
  }
}