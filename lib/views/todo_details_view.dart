import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app_with_3_screens/controllers/todolist_repository.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';
import 'package:todo_list_app_with_3_screens/helpers/helper.dart' as Helper;

class TodoDetailsView extends StatefulWidget {
  final Todo todo;
  TodoDetailsView({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoDetailsViewState createState() => _TodoDetailsViewState();
}

class _TodoDetailsViewState extends State<TodoDetailsView> {
  TextEditingController _textFieldController = TextEditingController();
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _isDone = widget.todo.done;
  }

  Future<void> _removeThisTodo() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Are you sure to remove this to-do?'),
              content: Text(widget.todo.content),
              actions: [
                TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      await context
                          .read<ToDoListRepository>()
                          .deleteATodoInDB(widget.todo);
                      Navigator.of(context).pop(true);
                    })
              ]);
        });
  }

  Future<void> _markDone() async {
    Todo newTodo = this.widget.todo;
    newTodo.done = !newTodo.done;
    setState(() {
      this._isDone = !this._isDone;
    });
    await context.read<ToDoListRepository>().updateTodoInDB(newTodo);
  }

  Future<bool> _onWillPop() async {
    if (_textFieldController.text.trim() ==
        widget.todo.content.toString().trim()) {
      return true;
    }
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
            title: new Text('Do you want save the to-do?'),
            content: new Text('Do you want save the to-do?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Todo newTodo = new Todo(
                    dateAdded: widget.todo.dateAdded,
                    dateLatestModified:
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    content: _textFieldController.text.toString(),
                    done: widget.todo.done,
                  );
                  await context
                      .read<ToDoListRepository>()
                      .updateTodoInDB(newTodo);
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = widget.todo;
    _textFieldController.text = todo.content;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(Helper.makeDateString(todo.dateAdded)),
              subtitle: Text("Date added"),
            ),
            ListTile(
              title: Text(Helper.makeDateString(todo.dateLatestModified)),
              subtitle: Text("Date modified"),
            ),
            ListTile(
              title: TextField(
                onChanged: (value) {},
                controller: _textFieldController,
                decoration: InputDecoration(
                    hintText: "You can change your content here:"),
              ),
            ),
            ListTile(
              title: this._isDone ? Text("This task is Done!") : Text(""),
            ),
            ListTile(
              title: RaisedButton.icon(
                color: Colors.blueAccent,
                icon: Icon(
                  this._isDone ? Icons.undo : Icons.check,
                  color: Colors.white,
                ),
                label: Text(this._isDone ? 'Undo this task' : 'Mark as Done',
                    style: new TextStyle(color: Colors.white)),
                onPressed: () async {
                  await _markDone();
                },
              ),
            ),
            ListTile(
              title: RaisedButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                color: Colors.redAccent,
                label: Text('Remove this to-do',
                    style: new TextStyle(color: Colors.white)),
                onPressed: () async {
                  await _removeThisTodo();
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
