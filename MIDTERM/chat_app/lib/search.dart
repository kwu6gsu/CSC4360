import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("first_name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No User Found!")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['uid'] != firebaseAuth.currentUser!.uid) {
          searchResult.add((user.data()));
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Enter name...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
              ),
              IconButton(
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchResult[index]['first_name'] +
                            " " +
                            searchResult[index]['last_name']),
                        trailing: IconButton(
                            onPressed: () {}, icon: Icon(Icons.message)),
                      );
                    }))
          else if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
