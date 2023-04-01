import 'package:intl/intl.dart';

class Helper {
  static formatDate(String dateTime, [String? format]) {
    var formatter = new DateFormat(format ?? 'yyyy-MM-dd');
    return formatter.format(DateTime.parse(dateTime));
  }
}