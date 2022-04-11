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
              title: Text('New todo'),
              content: TextField(
                onChanged: (value) {},
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Content for your todo"),
              ),
              actions: [
                RaisedButton(
                    child: Text("Save"),
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
                        print("Saved todo ? " + value.toString());
                        Navigator.of(context).pop();
                      });
                    })
              ]);
        });
  }

  Future<void> _markDone(Todo todo) async {
    Todo newTodo = todo;
    newTodo.done = !todo.done;
    await context.read<ToDoListRepository>().updateTodoInDB(newTodo);
    if (newTodo.done == true) {
      // Toast.show("Marked done!", context,
      //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
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
              return ListView.separated(
                separatorBuilder: (BuildContext context, int i) => Divider(),
                itemCount: _todos.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: InkWell(
                      child: Text(_todos[i].content),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TodoDetailsView(todo: _todos[i])));
                      },
                    ),
                    subtitle: Text("Modified " +
                        Helper.makeDateString(_todos[i].dateLatestModified)),
                    trailing: InkResponse(
                        onTap: () {
                          this._markDone(_todos[i]);
                        },
                        child: Icon(_todos[i].done
                            ? Icons.check_box
                            : Icons.check_box_outline_blank)),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add a To-do',
        child: Icon(Icons.add),
      ),
    );
  }
}
