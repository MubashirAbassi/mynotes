import 'package:flutter/material.dart';
import 'package:mynotes/screens/notedetail.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/utils/database_helper.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';


class notelist extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    return noteliststate();

  }
}

class noteliststate extends State<notelist> {
  databasehelper databaseHelper = databasehelper();
  late List<note> noteList;
  int count = 0;


  @override
  Widget build(BuildContext context) {

      noteList = <note>[];
      updatelistview();

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getlistview(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("fab clicked");
          navigatetodetain(note('','',2,),"Add Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getlistview() {
    TextStyle? textstyle = Theme
        .of(context)
        .textTheme
        .subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getprioritycolor(
                  this.noteList[position].priority),
              child: getpriorityicon(this.noteList[position].priority),
            ),
            title: Text(this.noteList[position].title, style: textstyle,),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                delete(context, noteList[position]);
              },
            ),

            onTap: () {
              debugPrint("listtile tapped");
              navigatetodetain(this.noteList[position],"Edit Note");
            },

          ),
        );
      },
    );
  }

  Color getprioritycolor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getpriorityicon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void navigatetodetain(note note,String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {

      return notedetail(note,title);

    }
    ));
    if(result == true){
      updatelistview();
    }


  }

  void delete(BuildContext context, note note) async {
    int result = await databaseHelper.deletenote(note.id);
    if (result != 0) {
      showsnackbar(context, "Note Seleted Sucessfully");
      updatelistview();
    }
  }

  void showsnackbar(BuildContext context, String massage) {
    final snackbar = SnackBar(content: Text(massage));
    Scaffold.of(context).showSnackBar(snackbar);
  }
void updatelistview(){
    final Future<Database> dbfuture = databaseHelper.initializedatabase();
    dbfuture.then((database){
      Future<List<note>> notelistfuture = databaseHelper.getnotelist();
      notelistfuture.then((notelist) {
        setState(() {
          this.noteList = notelist;
          this.count = notelist.length;
        });
      });
    } );
}
}

