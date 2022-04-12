import 'package:flutter/material.dart';
import 'package:todo_list_app_with_3_screens/database/persistent_database.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

class ToDoListRepository extends ChangeNotifier {
  List<Todo> currentTodos = [];
  TodoDAO todoDAO = TodoDAO();

  Future<List<Todo>> getSavedTodosFromDB() async {
    List<String> visiteds = [];
    List<Todo> toReturn = [];
    final List<Todo> todos = await todoDAO.getAllSortedByDateModified();
    todos.forEach((todo) {
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
    int? intToReturn = await todoDAO.insert(todo);
    if (intToReturn != null) {
      this.currentTodos.add(todo);
      notifyListeners();
    }
    return intToReturn!;
  }

  Future<int> updateTodoInDB(Todo todo) async {
    int toReturn = await todoDAO.update(todo);
    int index = currentTodos
        .indexWhere((element) => element.dateAdded == todo.dateAdded);
    currentTodos[index] = todo;
    notifyListeners();
    return toReturn;
  }

  Future<int> deleteATodoInDB(Todo todo) async {
    print("todo with contents ${todo.content} is being delete...");
    int intToReturn = await todoDAO.delete(todo);
    this
        .currentTodos
        .removeWhere((element) => element.dateAdded == todo.dateAdded);
    notifyListeners();
    return intToReturn;
  }

  Future<int> getCountSavedTodos() async {
    final todos = await todoDAO.getAllSortedByDateAdded();
    return todos.length;
  }
}
