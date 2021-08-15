import 'package:flutter/material.dart';
import 'package:mynotes/screens/notedetail.dart';
import 'package:mynotes/screens/notelist.dart';
void main(){
  runApp(
    myapp()
  );
}
class myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final Overflow overflow;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"Note Keeper",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: notelist(),
    );

  }
}