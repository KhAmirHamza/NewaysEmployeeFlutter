import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neways3/src/features/profile/presentation/MyHolidayCalender.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHolidaysScreen extends StatefulWidget {
  const MyHolidaysScreen({super.key});

  @override
  State<MyHolidaysScreen> createState() => _MyHolidaysScreenState();
}

class _MyHolidaysScreenState extends State<MyHolidaysScreen> {

//   DateTime now = DateTime.now();
// int lastday = DateTime(now.year, now.month + 1, 0).day;
// int startYear = DateTime.now().year;
// int startMonth = DateTime.now().month;
// int startDay = DateTime.now().day;
//
//
// CalendarFormat _calendarFormat = CalendarFormat.month;
 DateTime firstDay =  DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
 DateTime lastDay =  DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day);
// DateTime _focusedDay =  firstDay;
// DateTime? _selectedDay;


  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Holidays'),
      ),
      /*body: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
        eventLoader: (day) {
          if (day.weekday == DateTime.monday) {
            return [const Text('Cyclic event')];
          }

          return [];
        },



      ),*/

      body: Container(),
    );
  }

}
