import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mynotes/models/note.dart';

class databasehelper {
  static late  databasehelper _databasehelpers ;
  static late Database _database;



  String notetable = "note_table";
  String colid = "id";
  String coltitle = "title";
  String coldescription = "description";
  String colpriority = "priority";
  String coldate = "date";


  databasehelper._createinstance();

  factory databasehelper() {

    // if (_databasehelpers == null) {
      _databasehelpers = databasehelper._createinstance();
    // }
    return _databasehelpers;
  }

  Future<Database> get database async {

      _database = await initializedatabase();

    return _database;
  }

  Future<Database> initializedatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesdatabase = await openDatabase(
        path, version: 1, onCreate: createdb);
    return notesdatabase;
  }

  void createdb(Database db, int newversion) async {
    await db.execute(
        'CREATE TABLE $notetable($colid INTEGER PRIMARY KEY AUTOINCREMENT, $coltitle TEXT,$coldescription TEXT, $colpriority INTEGER, $coldate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getnotemaplist() async {
    Database db = await this.database;
    var result = db.rawQuery(
        'SELECT * FROM $notetable order by $colpriority ASC');
    return result;
  }

  Future<int> insertnote(note note) async {
    Database db = await this.database;
    var result = await db.insert(notetable, note.toMap());
    return result;
  }

  Future<int> updatenote(note note) async {
    Database db = await this.database;
    var result = await db.update(
        notetable, note.toMap(), where: '$colid = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deletenote(int? id) async {
    Database db = await this.database;
    var result = await db.rawDelete(
        'DELETE FROM $notetable WHERE $colid = $id');
    return result;
  }

  Future<int?> getcount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT COUNT (*) from $notetable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
  Future<List<note>> getnotelist() async{

    var notemaplist = await getnotemaplist();
    int count = notemaplist.length;

    List<note> notelist = <note>[];
    for(int i = 0; i<count; i++ ){
      notelist.add(note.fromMapObject(notemaplist[i]));
    }
  return notelist;
  }
}
