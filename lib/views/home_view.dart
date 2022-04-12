import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app_with_3_screens/controllers/todolist_repository.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';
import 'package:todo_list_app_with_3_screens/views/todo_details_view.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app_with_3_screens/helpers/helper.dart' as Helper;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textFieldController = TextEditingController();
  ToDoListRepository _todoRepo = ToDoListRepository();

  void _addTodo() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              key: const Key('add_todo_dialog'),
              title: Text('New todo'),
              content: TextField(
                onChanged: (value) {},
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Content for new to-do"),
              ),
              actions: [
                RaisedButton(
                    child: Text("Save"),
                    key: const Key('save-todo-button'),
                    onPressed: () {
                      this
                          ._todoRepo
                          .saveTodoToDB(new Todo(
                            dateAdded: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            dateLatestModified: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            content: _textFieldController.text.toString(),
                            done: false,
                          ))
                          .then((value) {
                        Navigator.of(context).pop();
                      });
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> _todos =
        context.watch<ToDoListRepository>().currentTodos.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Dos"),
      ),
      body: Center(
        child: FutureBuilder<List<Todo>>(
          future: context.read<ToDoListRepository>().getSavedTodosFromDB(),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: Colors.amber,
              );
            } else if (snapshot.hasError) {
              return CircularProgressIndicator(
                color: Colors.amber,
              );
            } else {
              return Column(
                children: [
                  Text(
                    "You have ${_todos.length} tasks",
                    key: const Key("tasks_count"),
                  ),
                  Expanded(
                    child: ListView.separated(
                      key: const Key("all_todos_list_view"),
                      separatorBuilder: (BuildContext context, int i) =>
                          Divider(),
                      itemCount: _todos.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TodoDetailsView(todo: _todos[i])));
                          },
                          title: Text(_todos[i].content),
                          subtitle: Text("Modified " +
                              Helper.makeDateString(
                                  _todos[i].dateLatestModified)),
                          trailing: Icon(_todos[i].done
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add a To-do',
        key: const Key('add_todo_button'),
        child: Icon(Icons.add),
      ),
    );
  }
}
