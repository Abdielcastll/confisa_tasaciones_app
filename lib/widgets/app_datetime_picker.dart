import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Pickers {
  static Future<String> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) selectedDate = picked;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(selectedDate);
  }

  static Future<String> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
    String time = "";
    String hour = "";
    String minute = "";
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    hour = selectedTime.hour.toString();
    hour = hour.length == 1 ? "0" + hour : hour;
    minute = selectedTime.minute.toString();
    minute = minute.length == 1 ? "0" + minute : minute;
    time = hour + ':' + minute + ":00.000";
    return time;
  }
}
