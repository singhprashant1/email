import 'package:firebase_database/firebase_database.dart';
import 'package:email/Model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fb = FirebaseDatabase.instance.reference().child("Userdata");
  List<Model> list = List();
  @override
  void initState() {
    super.initState();
    fb.once().then((DataSnapshot snap) {
      var data = snap.value;
      list.clear();
      data.forEach((key, value) {
        Model model = new Model(
          name: value['name'],
          number: value['number'],
          email: value['email'],
          key: key,
        );
        list.add(model);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
