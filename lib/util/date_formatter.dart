class DateFormatter {

  DateFormatter._();

  static String format(DateTime dateTime) {
    var year = dateTime.year.toString();
    var month = dateTime.month.toString();
    var day = dateTime.day.toString();
    var hour = dateTime.hour.toString();
    var minute = dateTime.minute.toString();
    var second = dateTime.minute.toString();
    return "$year年$month月$day日 $hour:$minute:$second";
  }
}