import 'package:flutter/foundation.dart';

class Todo {
  String dateAdded = ""; // this is also the ID for a todo
  String dateLatestModified = "";
  String content = "";
  bool done = false;

  Todo({
    required this.dateAdded,
    required this.dateLatestModified,
    required this.content,
    this.done = false,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    dateAdded = json['dateAdded'].toString();
    dateLatestModified = json['dateLatestModified'].toString();
    content = json['content'].toString();
    if (json['done'].toString() == "true") {
      done = true;
    } else {
      done = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateAdded'] = this.dateAdded;
    data['dateLatestModified'] = this.dateLatestModified;
    data['content'] = this.content;
    data['done'] = this.done.toString();
    debugPrint(data.toString());
    return data;
  }
}
