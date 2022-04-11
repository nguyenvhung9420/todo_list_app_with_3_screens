import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:todo_list_app_with_3_screens/database/persistent_database.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

class LocalDatabaseSpy extends Mock implements AppDatabase {}

void main() {
  LocalDatabaseSpy? localDatabaseSpy;
  TodoDAO? todoDao;
  String key;
  String value;

  Todo newTodo;

  setUp(() {
    // initDatabase();
    // localDatabaseSpy = LocalStorageSpy();
    todoDao = TodoDAO();

    key = faker.randomGenerator.string(4);
    value = faker.randomGenerator.string(10);
  });

  group("Testing save methods", () {
    test("Should save with correct values", () async {
      int dateAdded = faker.randomGenerator.integer(10000);
      newTodo = new Todo(
        dateAdded: dateAdded.toString(),
        dateLatestModified: DateTime.now().millisecondsSinceEpoch.toString(),
        content: faker.randomGenerator.string(12),
        done: false,
      );

      int? toBeReturned = await todoDao?.insert(newTodo);
      expect((toBeReturned == null), false);
      // verify(localStorage.setString(key, value));
    });

    // test('Should throw Exception if LocalStorage fails', () {
    //   newTodo = new Todo(
    //     dateAdded: DateTime.now().millisecondsSinceEpoch.toString(),
    //     dateLatestModified: DateTime.now().millisecondsSinceEpoch.toString(),
    //     content: faker.randomGenerator.string(12),
    //     done: false,
    //   );
    //   when(todoDao?.insert(newTodo)).thenThrow(Exception());

    //   final future = sut.save(key: key, value: value);

    //   expect(future, throwsA(TypeMatcher<Exception>()));
    // });
  });

  group('Fetch method', () {
    test('Should call LocalStorage with correct values', () async {
      int dateAdded = faker.randomGenerator.integer(10000);
      Todo? retrievedTodo =
          await todoDao?.getTodoWithDateAdded(dateAdded.toString());
      expect((retrievedTodo == null), false);
    });

    // test('Should return a value with success', () async {
    //   when(localStorage.getString(any)).thenAnswer((_) => value);

    //   final valueResult = await sut.fetch(key: key);

    //   expect(valueResult, value);
    // });

    // test('Should throw Exception if LocalStorage fails', () {
    //   when(localStorage.getString(any)).thenThrow(Exception());

    //   final future = sut.fetch(key: key);

    //   expect(future, throwsA(TypeMatcher<Exception>()));
    // });
  });

  test('my_unit_test', () async {
    var factory = newDatabaseFactoryMemory();
    var store = StoreRef.main();
    var db = await factory.openDatabase('sembast.db');
    Todo todo = new Todo(
        dateAdded: "1649561407509",
        dateLatestModified: "1649561407510",
        content: "HUNG",
        done: false);

    int key = await store.add(db, todo.toJson());
    var record = store.record(key);
    expect(await record.get(db), todo.toJson());
    expect(key, 1);
    await db.close();
  });
}
