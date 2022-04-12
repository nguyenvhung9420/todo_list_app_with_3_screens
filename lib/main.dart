import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app_with_3_screens/database/persistent_database.dart';
import 'package:todo_list_app_with_3_screens/controllers/todolist_repository.dart';
import 'package:todo_list_app_with_3_screens/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ToDoListRepository()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage()

        // FutureBuilder(
        //   future: initDatabase(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       return MyHomePage();
        //     } else {
        //       return Material(
        //         child: Center(
        //           child: CircularProgressIndicator(),
        //         ),
        //       );
        //     }
        //   },
        // ),
        );
  }
}
