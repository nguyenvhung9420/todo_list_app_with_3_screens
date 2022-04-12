import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:todo_list_app_with_3_screens/database/persistent_database.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

void main() {
  TodoDAO? todoDao;
  Todo newTodo;

  int keyToTestStaticItem = faker.randomGenerator.integer(100);

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    var factory = newDatabaseFactoryMemory();
    todoDao = TodoDAO(db: factory.openDatabase('sembast.db'));
  });

  group("Testing save methods", () {
    test("- Saved with success", () async {
      int dateAdded = faker.randomGenerator.integer(10000);
      newTodo = new Todo(
        dateAdded: dateAdded.toString(),
        dateLatestModified: DateTime.now().millisecondsSinceEpoch.toString(),
        content: faker.randomGenerator.string(12),
        done: false,
      );

      int? toBeReturned = await todoDao?.insert(newTodo);
      expect((toBeReturned == null), false);
    });

    test("- Both saved and retrieved with success", () async {
      int dateAdded = faker.randomGenerator.integer(10000);
      newTodo = new Todo(
        dateAdded: dateAdded.toString(),
        dateLatestModified: DateTime.now().millisecondsSinceEpoch.toString(),
        content: faker.randomGenerator.string(12),
        done: false,
      );
      int? key = await todoDao?.insert(newTodo);
      Todo? justSavedTodo = await todoDao?.getTodoWithKey(key!);
      expect(justSavedTodo?.toJson(), newTodo.toJson());
    });
  });

  group('Fetch method', () {
    test('- Get one null item', () async {
      Todo? retrievedTodo =
          await todoDao?.getTodoWithDateAdded(keyToTestStaticItem.toString());
      expect((retrievedTodo == null), false);
    });
  });
}
