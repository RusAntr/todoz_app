import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:date_time_format/src/date_time_extension_methods.dart';
import '../data/models/models.dart';

class DateTimeFormatting {
  /// Returns properly formatted dateUntil property of a [TodoModel]
  static String countUntilTime(Timestamp due) {
    String outputDate;
    DateTime dateDue = due.toDate();
    Duration timeUntil = dateDue.difference(DateTime.now());
    int daysUntil = timeUntil.inDays;
    int hoursUntil = timeUntil.inHours - (daysUntil * 24);
    int minUntil =
        timeUntil.inMinutes - (daysUntil * 24 * 60) - (hoursUntil * 60);
    if (daysUntil > 0) {
      outputDate =
          daysUntil.toString() + "days".tr + hoursUntil.toString() + "hours".tr;
    } else if (hoursUntil > 0) {
      outputDate = hoursUntil.toString() +
          "hours".tr +
          minUntil.toString() +
          "minutes".tr;
    } else if (minUntil > 0) {
      outputDate = minUntil.toString() + "minutes".tr;
    } else {
      outputDate = 'till'.tr + dateDue.format('j.m.Y, h:i');
    }
    return outputDate;
  }

  /// Returns properly formatted duration property of a [TodoModel]
  static String toDoProgressDuration(Timestamp duration) {
    String outputDate = '';
    DateTime dateDue = duration.toDate();
    Duration timeUntil = dateDue.difference(
      DateTime(dateDue.year, dateDue.month, dateDue.day),
    );
    int daysUntil = timeUntil.inDays;
    int hoursUntil = timeUntil.inHours - (daysUntil * 24);
    int minUntil =
        timeUntil.inMinutes - (daysUntil * 24 * 60) - (hoursUntil * 60);
    int secUntil = timeUntil.inSeconds - (minUntil * 60);
    String s = secUntil.toString().length <= 2
        ? secUntil.toString()
        : secUntil.toString().substring(secUntil.toString().length - 2);
    if (daysUntil > 0) {
      outputDate =
          daysUntil.toString() + "days".tr + hoursUntil.toString() + "hours".tr;
    } else if (hoursUntil > 0) {
      outputDate = hoursUntil.toString() +
          "hours".tr +
          minUntil.toString() +
          "minutes".tr;
    } else if (minUntil > 0) {
      outputDate = minUntil.toString() + "minutes".tr;
    } else if (secUntil > 0) {
      outputDate = s.toString() + "seconds".tr;
    }
    return outputDate;
  }

  /// Returns properly formatted minutes & hours from seconds
  static String howMuchTimePassed(int seconds) {
    String timePassed = '';
    int _hour = (seconds ~/ 3600).toInt();
    int _minute = (seconds ~/ 60).toInt();
    if (_hour >= 0) {
      timePassed = _hour.toString() +
          'hours'.tr +
          (_minute % 60).toString() +
          'minutes'.tr +
          (seconds % 60).toString() +
          'seconds'.tr;
    }
    return timePassed;
  }

  /// Returns the correct name for the day of the week
  static String _getNameOfTheDay(int dayNumber) {
    switch (dayNumber) {
      case 0:
        return 'monday'.tr;
      case 1:
        return 'tuesday'.tr;
      case 2:
        return 'wednesday'.tr;
      case 3:
        return 'thursday'.tr;
      case 4:
        return 'friday'.tr;
      case 5:
        return 'saturday'.tr;
      case 6:
        return 'sunday'.tr;
      default:
        return 'monday'.tr;
    }
  }

  /// Returns correct day of the week for [LineChart]'s [LineTooltipItem]
  static String dayOfTheWeek(int xAxis) {
    var date = DateTime.now().subtract(Duration(days: 6 - xAxis));
    return _getNameOfTheDay(date.weekday - 1) + ' ' + date.day.toString();
  }

  /// Returns properly formatted date to be more readable (D 00, M 00, Y 0000)
  static String dateText(bool areAllTasks, String day, DateTime dateTime) {
    String dateText = '';
    if (!areAllTasks) {
      dateText = day.tr + dateTime.format('j.m Y');
    } else {
      dateText = 'allTasks'.tr;
    }
    return dateText;
  }

  /// Returns properly formatted string from [DateTime] to be more readable (D 00, M 00, Y 0000)
  static String correctFormatDate(TodoModel todoModel) {
    String correctFormatDate;
    if (todoModel.dateUntil != null) {
      correctFormatDate = todoModel.dateUntil!.toDate().format('j.m.Y, h:i');
    } else {
      correctFormatDate = '';
    }
    return correctFormatDate;
  }
}
