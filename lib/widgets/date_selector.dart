import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  var today = DateTime.now();
  var _checkInDay = DateTime.now();
  var _checkOutDay = DateTime.now().add(Duration(days: 1));

  // void _onDaySelected(DateTime day, DateTime focusedDay) {
  //   setState(() {
  //     today = day;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (ctx, innerSetState) => TableCalendar(
                            locale: "en_US",
                            rowHeight: 40,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (selectedDay) =>
                                isSameDay(selectedDay, _checkInDay),
                            focusedDay: _checkInDay,
                            firstDay: today,
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            onDaySelected: (selectedDay, fday) {
                              // this changes state of the bottom sheet only
                              innerSetState(() => _checkInDay = selectedDay);
                              // this changes state of the entire parent widget (i.e date selector)
                              setState(() {
                                _checkInDay = selectedDay;
                                _checkOutDay =
                                    _checkInDay.add(Duration(days: 1));
                              });
                            },
                          ),
                        );
                      });
                },
                child: Text(
                    "Check in : " + DateFormat('MMMMd').format(_checkInDay))),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (ctx, innerSetState) => TableCalendar(
                            locale: "en_US",
                            rowHeight: 40,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate: (selectedDay) =>
                                isSameDay(selectedDay, _checkOutDay),
                            focusedDay: _checkInDay.add(Duration(days: 1)),
                            firstDay: _checkInDay.add(Duration(days: 1)),
                            lastDay: today.add(Duration(days: 364)),
                            onDaySelected: (selectedDay, fday) {
                              // this changes state of the bottom sheet only
                              innerSetState(() => _checkOutDay = selectedDay);
                              // this changes state of the entire parent widget (i.e date selector)
                              setState(() {
                                _checkOutDay = selectedDay;
                              });
                            },
                          ),
                        );
                      });
                },
                child: Text(
                    "Check out : " + DateFormat('MMMMd').format(_checkOutDay))),
          ],
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.search))
      ],
    );
  }
}


 // TableCalendar(
        //   locale: "en_US",
        //   rowHeight: 43,
        //   headerStyle:
        //       HeaderStyle(formatButtonVisible: false, titleCentered: true),
        //   availableGestures: AvailableGestures.all,
        //   selectedDayPredicate: (day) => isSameDay(day, today),
        //   focusedDay: today,
        //   firstDay: DateTime.now(),
        //   lastDay: DateTime.now().add(Duration(days: 365)),
        //   onDaySelected: _onDaySelected,
        // ),