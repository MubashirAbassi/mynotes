import 'dart:async';

import 'package:mynotes/screens/notelist.dart';

import 'package:flutter/material.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/utils/database_helper.dart';

import 'package:intl/intl.dart';

class notedetail extends StatefulWidget {
  final String appbartitle;
  late note notes;

  notedetail(this.notes, this.appbartitle);

  @override
  State<StatefulWidget> createState() {
    return notedetailstate(this.notes, this.appbartitle);
  }
}

class notedetailstate extends State<notedetail> {
  static var priorities = ["high", "low"];

  databasehelper helper = databasehelper();
  String appbartitle;
  late note notes;

  notedetailstate(this.notes, this.appbartitle);

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titlecontroller.text = notes.title;
    descriptioncontroller.text = notes.description;
    TextStyle? textstyle = Theme.of(context).textTheme.subhead;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        throw ("");
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(appbartitle),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textstyle,
                  value: getpriorityasstring(notes.priority),
                  onChanged: (dynamic valueselectedbyuser) {
                    setState(() {
                      debugPrint("user selected $valueselectedbyuser");
                      updatepriorityasint(valueselectedbyuser);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titlecontroller,
                  style: textstyle,
                  onChanged: (value) {
                    debugPrint("something changed in title textfield");
                    updatetitle();
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: textstyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptioncontroller,
                  style: textstyle,
                  onChanged: (value) {
                    debugPrint("something changed in description textfield");
                    updatedescription();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textstyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "SAVE",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("save button clicked");
                          save();
                        });
                      },
                    )),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "DELETE",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("delete button clicked");
                          delete();
                        });
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void movetolastscreen(){
    Navigator.pop(context,true);
  }

  void updatepriorityasint(String value){
    switch (value){
      case 'high':
        notes.priority = 1;
        break;
      case 'low':
        notes.priority = 2;
        break;

    }


  }

  String getpriorityasstring(int value){
    late String priority;
    switch (value){
      case 1:
        priority = priorities[0];
        break;
      case 2:
        priority = priorities[1];
        break;
    }
    return priority;
  }

  void updatetitle(){
    notes.title = titlecontroller.text;
  }

  void updatedescription(){
    notes.description = descriptioncontroller.text;
  }

  void save() async{
   movetolastscreen();
    notes.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(notes.id !=null){
        result = await helper.updatenote(notes);
    }
    else{
        result = await helper.insertnote(notes);
    }
    if(result != 0 ){
      showalertdialog('Status','Note saved sucessfully');
    }
    else{
      showalertdialog('Status','problem saving node');
    }
  }

  void showalertdialog(String title, String massage){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(massage),
    );
    showDialog(context: context,
        builder: (_) => alertDialog
    );
  }

  void delete() async{
    movetolastscreen();
    if(notes.id == null){
      showalertdialog('status', 'No Note was deleted');
      return;
    }
    int result = await helper.deletenote(notes.id);
    if(result != 0){
      showalertdialog('status', 'Note Deleted sucessfully');
    }
    else{
      showalertdialog('status', 'Error Occered during deleting note');

    }
  }

}
