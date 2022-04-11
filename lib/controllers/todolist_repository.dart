import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

class ToDoListRepository extends ChangeNotifier {
  Database _database = GetIt.I.get();
  StoreRef _store = intMapStoreFactory.store("recent_beneficiary_store");
  List<Todo> currentTodos = [];

  Future<List<Todo>> getSavedTodosFromDB() async {
    final snapshots = await _store.find(_database);
    List<String> visiteds = [];
    List<Todo> toReturn = [];

    snapshots.forEach((snapshot) {
      Todo todo = Todo.fromJson(snapshot.value);
      if (!visiteds.contains(todo.dateAdded)) {
        toReturn.add(todo);
        visiteds.add(todo.dateAdded);
      }
    });
    toReturn.sort((prev, next) => prev.dateAdded.compareTo(next.dateAdded));
    currentTodos = toReturn;
    notifyListeners();
    return toReturn;
  }

  Future<int> saveTodoToDB(Todo todo) async {
    debugPrint("todo ${todo.content} is being saved...");
    int intToReturn = await _store.add(_database, todo.toJson());
    if (intToReturn == 1) {
      // 1 means successfully added new record
      this.currentTodos.add(todo);
      notifyListeners();
    }
    return intToReturn;
  }

  Future<int> updateTodoInDB(Todo todo) async {
    // await this.deleteATodoInDB(todo);
    // int toReturn = await this.saveTodoToDB(todo);
    var filter = Filter.equals("dateAdded", todo.dateAdded);
    var finder = Finder(filter: filter);
    int toReturn =
        await _store.update(_database, todo.toJson(), finder: finder);
    return toReturn;
  }

  Future<Todo> getTodoWithDateAdded(String dateAddesStamp) async {
    // await this.deleteATodoInDB(todo);
    // int toReturn = await this.saveTodoToDB(todo);
    var filter = Filter.equals("dateAdded", dateAddesStamp);
    var finder = Finder(filter: filter);
    final snapshot = await _store.findFirst(_database, finder: finder);
    return new Todo.fromJson(snapshot?.value);
  }

  Future<int> deleteATodoInDB(Todo todo) async {
    print(
        "todo with contents ${todo.content.substring(0, 10)} is being saved...");
    // Delete all records with a price greater then 10
    var filter = Filter.equals("dateAdded", todo.dateAdded);
    var finder = Finder(filter: filter);
    int intToReturn = await _store.delete(_database, finder: finder);
    // if (intToReturn == 1) {
    // 1 means successfully remove new record
    this
        .currentTodos
        .removeWhere((element) => element.dateAdded == todo.dateAdded);
    notifyListeners();
    // }
    return intToReturn;
  }

  Future<int> getCountSavedTodos() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => Todo.fromJson(snapshot.value))
        .toList(growable: false)
        .length;
  }

  Future<bool> clearSavedTodos() async {
    try {
      await _store.delete(_database);
      return true;
    } catch (e) {
      print("Error when clearing the database: " + e.toString());
      return false;
    }
  }
}
