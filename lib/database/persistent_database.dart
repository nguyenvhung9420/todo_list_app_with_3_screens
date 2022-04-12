import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:convert';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:todo_list_app_with_3_screens/controllers/todolist_repository.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

// Future<void> initDatabase() async {
//   try {
//     final appDir = await getApplicationDocumentsDirectory();
//     await appDir.create(recursive: true);
//     final databasePath = join(appDir.path, "sembast.db");
//     final db = await databaseFactoryIo.openDatabase(databasePath);
//     GetIt.I.registerSingleton<Database>(db);
//     GetIt.I
//         .registerLazySingleton<ToDoListRepository>(() => ToDoListRepository());
//   } catch (e) {
//     print("Error with initDatabase(): " + e.toString());
//   }
// }

class AppDatabase {
  static AppDatabase get instance => _singleton;
  static final AppDatabase _singleton = AppDatabase._();

  Completer<Database>? _dbOpenCompleter;
  AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future openDatabase({Database? db}) async {
    if (db != null) {
      _dbOpenCompleter?.complete(db);
      return;
    }
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, "sembast.db");
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter?.complete(database);
  }
}

class TodoDAO {
  static const String FRUIT_STORE_NAME = 'todos';
  final _fruitStore = intMapStoreFactory.store(FRUIT_STORE_NAME);
  late Future<Database> _db;

  TodoDAO({Future<Database>? db}) {
    if (db != null) {
      _db = db;
      return;
    }
    _db = AppDatabase.instance.database;
  }

  Future<int?> insert(Todo todo) async {
    Database db = await _db;
    int? keyReturned = await _fruitStore.add(db, todo.toJson());
    return keyReturned;
  }

  Future<int> update(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.dateAdded));
    int val =
        await _fruitStore.update(await _db, todo.toJson(), finder: finder);
    return val;
  }

  Future<Todo?> getTodoWithDateAdded(String dateAddesStamp) async {
    var filter = Filter.equals("dateAdded", dateAddesStamp);
    var finder = Finder(filter: filter);
    final snapshot = await _fruitStore.findFirst(await _db, finder: finder);
    if (snapshot?.value == null) return null;
    var mappedValue = json.decode(json.encode(snapshot?.value));
    return new Todo.fromJson(mappedValue);
  }

  Future<Todo> getTodoWithKey(int snapshotKey) async {
    var record = _fruitStore.record(snapshotKey);
    final res = await record.get(await _db);
    var mappedValue = json.decode(json.encode(res));
    return new Todo.fromJson(mappedValue);
  }

  Future<int> delete(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.dateAdded));
    int val = await _fruitStore.delete(await _db, finder: finder);
    return val;
  }

  Future<List<Todo>> getAllSortedByDateAdded() async {
    final finder = Finder(sortOrders: [SortOrder('dateAdded')]);
    final recordSnapshots = await _fruitStore.find(
      await _db,
      finder: finder,
    );
    return recordSnapshots.map((snapshot) {
      final fruit = Todo.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }

  Future<List<Todo>> getAllSortedByDateModified() async {
    final finder = Finder(sortOrders: [SortOrder('dateLatestModified')]);

    final recordSnapshots = await _fruitStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final fruit = Todo.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }
}
