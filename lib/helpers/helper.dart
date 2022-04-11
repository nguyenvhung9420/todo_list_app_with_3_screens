import 'package:intl/intl.dart';

String makeDateString(String timestamp) {
  var date =
      new DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  DateFormat formatter = DateFormat('MMM dd HH:mm:ss a');
  String formatted = formatter.format(date);
  if (date.day == DateTime.now().day &&
      date.month == DateTime.now().month &&
      date.year == DateTime.now().year) {
    formatter = DateFormat(' HH:mm:ss a');
    formatted = 'Today' + formatter.format(date);
  }
  return formatted;
}
