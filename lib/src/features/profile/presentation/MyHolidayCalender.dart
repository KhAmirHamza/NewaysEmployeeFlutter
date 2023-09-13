// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:neways3/src/features/profile/controller/ProfileController.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class MyHolidayCalender extends StatefulWidget {
  ProfileController controller;
  MyHolidayCalender(this.controller, {super.key});

  @override
  State<MyHolidayCalender> createState() => _MyHolidayCalenderState();
}

class _MyHolidayCalenderState extends State<MyHolidayCalender> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  
  
  List<int> holidays = [];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    for(int i =0; i<widget.controller.holidays.length; i++){
      holidays.add(widget.controller.holidays[i].day![0]=='0'?
      int.parse(widget.controller.holidays[i].day!.substring(1))
          : int.parse(widget.controller.holidays[i].day!));
    }

  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    
   // print("_getEventsForDay:${widget.controller.holidays.length}");
    // Implementation example
    //return kEvents[day] ?? [];

    List<Event> events = [];

    String currentDay = day.day<10? "0${day.day}": "${day.day}";

    for(int i =0; i<widget.controller.holidays.length; i++){
     // print("day.day: ${day.day}, widget.controller.holidays[i].day: ${widget.controller.holidays[i].day}");
      if(currentDay==widget.controller.holidays[i].day){
        events = [Event(widget.controller.holidays[i].reason!)];
      }
    }

    return events;


  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Holidays'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>  holidays.contains(day.day),   //isSameDay(_selectedDay, day),
           // rangeStartDay: _rangeStart,
           // rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            //rangeSelectionMode: _rangeSelectionMode,

            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              markerSize: 0,
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(25)
              ),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
          //  onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}