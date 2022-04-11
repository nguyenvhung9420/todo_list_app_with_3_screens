import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:todo_list_app_with_3_screens/controllers/todolist_repository.dart';
import 'package:todo_list_app_with_3_screens/models/todo.dart';

Future<void> initDatabase() async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "sembast.db");
    final db = await databaseFactoryIo.openDatabase(databasePath);

    // var store = StoreRef.main();
    GetIt.I.registerSingleton<Database>(db);
    GetIt.I
        .registerLazySingleton<ToDoListRepository>(() => ToDoListRepository());
  } catch (e) {
    print("Error with initDatabase(): " + e.toString());
  }
}

class AppDatabase {
  // Singleton accessor
  static AppDatabase get instance => _singleton;

  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // Sembast database object
  Database? _database;

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'sembast.db');

    final database = await databaseFactoryIo.openDatabase(dbPath);
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter?.complete(database);
  }
}

class TodoDAO {
  // Data Access Object of Todos
  static const String FRUIT_STORE_NAME = 'todos';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _fruitStore = intMapStoreFactory.store(FRUIT_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<int?> insert(Todo todo) async {
    await _fruitStore.add(await _db, todo.toJson());
  }

  Future update(Todo todo) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(todo.dateAdded));
    await _fruitStore.update(
      await _db,
      todo.toJson(),
      finder: finder,
    );
  }

  Future<Todo> getTodoWithDateAdded(String dateAddesStamp) async {
    // await this.deleteATodoInDB(todo);
    // int toReturn = await this.saveTodoToDB(todo);
    var filter = Filter.equals("dateAdded", dateAddesStamp);
    var finder = Finder(filter: filter);
    final snapshot = await _fruitStore.findFirst(await _db, finder: finder);
    return new Todo.fromJson(snapshot?.value as Map<String, dynamic>);
  }

  Future delete(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.dateAdded));
    await _fruitStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Todo>> getAllSortedByDateAdded() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [SortOrder('dateAdded')]);

    final recordSnapshots = await _fruitStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final fruit = Todo.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      // fruit.dateAdded = snapshot.key;
      return fruit;
    }).toList();
  }

  Future<List<Todo>> getAllSortedByDateModified() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [SortOrder('dateLatestModified')]);

    final recordSnapshots = await _fruitStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final fruit = Todo.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      // fruit.dateLatestModified = snapshot.key;
      return fruit;
    }).toList();
  }

  // dateLatestModified
}
