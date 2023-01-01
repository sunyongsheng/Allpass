class DateFormatter {

  DateFormatter._();

  static String format(DateTime dateTime) {
    var year = dateTime.year;
    var month = optimizeFormat(dateTime.month);
    var day = optimizeFormat(dateTime.day);
    var hour = optimizeFormat(dateTime.hour);
    var minute = optimizeFormat(dateTime.minute);
    var second = optimizeFormat(dateTime.second);
    return "$year-$month-$day $hour:$minute:$second";
  }

  static String formatToFilename(DateTime dateTime) {
    var year = dateTime.year;
    var month = optimizeFormat(dateTime.month);
    var day = optimizeFormat(dateTime.day);
    var hour = optimizeFormat(dateTime.hour);
    var minute = optimizeFormat(dateTime.minute);
    var second = optimizeFormat(dateTime.second);
    return "$year$month${day}_$hour$minute$second";
  }

  static String optimizeFormat(int number) {
    if (number < 10) {
      return "0$number";
    }
    return number.toString();
  }
}