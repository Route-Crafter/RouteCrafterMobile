abstract class DataFormatter {
  DateTime getDateFromString(String date);
  String getStringFromDate(DateTime date);
}

class DataFormatterImpl implements DataFormatter{
  @override
  DateTime getDateFromString(String date) {
    final parts = date.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');
    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1])
    );
  }
    
  @override
  String getStringFromDate(DateTime date)  =>
    '${date.year}-${_getFormattedNumber(date.month)}-${_getFormattedNumber(date.day)} ${_getFormattedNumber(date.hour)}:${_getFormattedNumber(date.minute)}';

    String _getFormattedNumber(int number) =>
    '${number<10?"0":""}$number';
}