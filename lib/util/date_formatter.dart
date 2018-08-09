import 'package:intl/intl.dart';

String dateFormatted(){
  var now = DateTime.now();
  var formater = DateFormat("EEE, MM d, ''yy");
  String formatted = formater.format(now);
  return formatted;
}