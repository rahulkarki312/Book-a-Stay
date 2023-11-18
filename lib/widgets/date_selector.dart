import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/userfilter.dart';
import '../providers/hotels.dart';

class DateSelector extends StatefulWidget {
  @override
  State<DateSelector> createState() => _DateSelectorState();
  DateSelector({this.showLocationFilter = true});
  bool showLocationFilter;
}

class _DateSelectorState extends State<DateSelector> {
  var today = DateTime.now();
  var _checkInDay = DateTime.now();
  var _checkOutDay = DateTime.now().add(Duration(days: 1));
  int customerCount = 1;
  String? _selectedLocation;

  // void _onDaySelected(DateTime day, DateTime focusedDay) {
  //   setState(() {
  //     today = day;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController = TextEditingController();
    // for location input

    List<String> locations = Provider.of<Hotels>(context).locations;
    final List<DropdownMenuEntry<String>> locationEntries =
        <DropdownMenuEntry<String>>[];
    for (final location in locations) {
      locationEntries.add(
        DropdownMenuEntry<String>(value: location, label: location),
      );
    }

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
                            calendarStyle: const CalendarStyle(
                                todayDecoration:
                                    BoxDecoration(color: Colors.amber)),
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
                                if (!_checkInDay.isBefore(_checkOutDay) &&
                                    _checkInDay == _checkOutDay) {
                                  _checkOutDay =
                                      _checkInDay.add(Duration(days: 1));
                                }
                                if (_checkInDay.isAfter(_checkOutDay)) {
                                  _checkOutDay =
                                      _checkInDay.add(Duration(days: 1));
                                }
                              });
                            },
                          ),
                        );
                      });
                },
                child: Row(
                  children: [
                    const Text("Check in : "),
                    Text(
                      DateFormat('MMMd').format(_checkInDay),
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                )),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (ctx, innerSetState) => TableCalendar(
                            calendarStyle: const CalendarStyle(
                                todayDecoration:
                                    BoxDecoration(color: Colors.amber)),
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
                child: Row(
                  children: [
                    const Text("Check Out : "),
                    Text(
                      DateFormat('MMMd').format(_checkOutDay),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  if (customerCount > 1) {
                    customerCount--;
                    setState(() {});
                  }
                },
                child: Icon(Icons.text_decrease)),
            Icon(Icons.person_2),
            Text(customerCount.toString()),
            TextButton(
              onPressed: () {
                customerCount++;
                setState(() {});
              },
              child: Icon(Icons.text_increase),
            )
          ],
        ),
        if (widget.showLocationFilter)
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<String>(
                      controller: locationController,
                      // enableFilter: true,
                      leadingIcon: const Icon(Icons.location_city),
                      label: const Text('location'),
                      dropdownMenuEntries: locationEntries,
                      onSelected: (String? location) {
                        setState(() {
                          _selectedLocation = location;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (!widget.showLocationFilter)
          const SizedBox(
            height: 15,
          ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Provider.of<UserFilter>(context, listen: false).setFilter(
                  _checkInDay, _checkOutDay, _selectedLocation, customerCount);
              if (!widget.showLocationFilter) {
                // since this may be called from show modal
                Navigator.of(context).pop();
              }
            },
            child: const Text("Set Filter"))
      ],
    );
  }
}
