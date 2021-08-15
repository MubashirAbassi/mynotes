

class note {
  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority;

  note(this._title,this._date,this._priority,[this._description]);

  note.withid(this._id,this._title,this._date,this._priority,[this._description]);

  int? get id => _id;
  String get title  => title;
  String get description => description;
  int get priority => priority;
  String get date => date;

  set title(String newtitle){
    if(newtitle.length>255){
      this._title=newtitle;
    }

  }
  set description(String newdescription){
    if(newdescription.length>255){
      this._description=newdescription;
    }
  }
  set priority(int newpriority){
    if(newpriority>=1 && newpriority<=2){
      this._priority=newpriority;
    }
  }
  set date(String newdate){

      this._date=newdate;

  }

//  convert note into map :
Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id!=null){
  map["id"] = _id;
  }
    map["title"] = _title;
    map["description"] = _description;
    map["proirity"] = _priority;
    map["date"] = _date;
   return map;
}

//extract a note object from a map object:
 note.fromMapObject(Map<String,dynamic>map){
    this._id=map["id"];
    this._title=map["title"];
    this._description=map["description"];
    this._priority=map["priority"];
    this._date=map["date"];
 }

}