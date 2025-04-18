import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final tod = TimeOfDay.fromDateTime(date);
    return '${tod.hourOfPeriod}:${tod.minute.toString().padLeft(2, '0')} ${tod.period.name.toUpperCase()}';
  
  }
  

  static String getMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();


    final tod = TimeOfDay.fromDateTime(sent);
    final formattedTime = '${tod.hourOfPeriod}:${tod.minute.toString().padLeft(2, '0')} ${tod.period.name.toUpperCase()}';
  

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year ? '${formattedTime} - ${sent.day} ${_getMonth(sent)}' :
    
    
    '${formattedTime} - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      final tod = TimeOfDay.fromDateTime(sent);
      return '${tod.hourOfPeriod}:${tod.minute.toString().padLeft(2, '0')} ${tod.period.name.toUpperCase()}';
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  static String getLastActiveTime({
    required BuildContext context,
    required String lastActive,
  }) {
    final int i = int.tryParse(lastActive) ?? -1;
    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    // String formattedTime = TimeOfDay.fromDateTime(time).format(context);

     final tod = TimeOfDay.fromDateTime(time);
    String formattedTime = '${tod.hourOfPeriod}:${tod.minute.toString().padLeft(2, '0')} ${tod.period.name.toUpperCase()}';
  

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }
    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month at $formattedTime';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}


// class MyDateUtil {
//   static String getFormattedTime({required BuildContext context, required String time}){
//     final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
//     return TimeOfDay.fromDateTime(date).format(context);
//   }
// }

