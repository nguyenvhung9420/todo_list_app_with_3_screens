import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_list_app_with_3_screens/main.dart' as app;

void main() {
  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  group("Test adding a todo", () {
    testWidgets('Test to check ListView', (WidgetTester tester) async {
      await tester.pumpWidget(app.MyApp());
      int count = tester
          .widgetList<ListView>(find.byKey(Key("all_todos_list_view")))
          .length;
      expect(count, 1);
    });
  });

  testWidgets('Test adding new todo', (WidgetTester tester) async {
    Finder plusTodoBttn = find.byTooltip('Add a To-do');
    await tester.tap(plusTodoBttn);
    await tester.pumpAndSettle();
    int adddingDialog =
        tester.widgetList<Dialog>(find.byKey(Key("add_todo_dialog"))).length;
    expect(find.byKey(Key("add_todo_dialog")), findsOneWidget);
  });
}
