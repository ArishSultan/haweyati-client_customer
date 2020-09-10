import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/utils/date-formatter.dart';
import 'package:haweyati/src/models/time-slot_model.dart';
import 'package:haweyati/services/time-slots_service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';

class DropOffPicker extends StatefulWidget {
  final ServiceType service;
  final TimeSlot initialTime;
  final DateTime initialDate;
  final Function(DateTime date) onDateChanged;
  final Function(TimeSlot time) onTimeChanged;

  DropOffPicker({
    this.service = ServiceType.dumpsters,
    this.initialDate,
    this.initialTime,
    this.onDateChanged,
    this.onTimeChanged
  });

  @override
  _DropOffPickerState createState() => _DropOffPickerState();
}

class _DropOffPickerState extends State<DropOffPicker> {
  TimeSlot _timeSlot;
  List<TimeSlot> _intervals;
  TimeSlot _selectedTimeSlot;

  DateTime _lastDate;
  DateTime _firstDate;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    TimeSlotsService().getTimeSlotsOf(widget.service).then((value) {
      _timeSlot = value;
      final _now = DateTime.now().add(Duration(hours: 12));

      if (TimeOfDay.fromDateTime(_now) < _timeSlot.to) {
        _firstDate = _now;
      } else {
        _firstDate = DateTime(_now.year, _now.month, _now.day, _now.hour);
      }

      if (widget.initialDate?.isAfter(_firstDate) ?? false) {
        _selectedDate = widget.initialDate;
      } else {
        _selectedDate = _firstDate;
        widget.onDateChanged(_selectedDate);
      }
      _intervals = value.intervals(_selectedDate);
      if (widget.initialTime != null) {
        _selectedTimeSlot = widget.initialTime;
      } else {
        _selectedTimeSlot = _intervals.first;
      }
      _lastDate = _firstDate.add(Duration(hours: 100));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_timeSlot == null) {
      child = _buildFirstChild();
    } else {
      child = _buildMainChild();
    }

    return Container(
      height: 81,
      child: child,
    );
  }

  _buildFirstChild() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 11),
        child: Text('Drop-off Details', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 13
        )),
      ),
      Expanded(child: DarkContainer(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          child: Row(children: [
            Expanded(
              child: Text('Calculating Available Time Slots'),
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ]),

          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: _firstDate,
              lastDate: _lastDate
            );

            if (date != null) {
              setState(() {
                _selectedDate = date;
                _intervals = _timeSlot.intervals(date);
                _selectedTimeSlot = _intervals.first;
              });

              widget.onDateChanged(_selectedDate);
            }
          }
        )
      )),
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }

  _buildMainChild() {
    return Column(children: [
      Row(children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Text('Drop-off Date', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13
          )),
        )),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 17),
          child: Text('Drop-off Time', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13
          )),
        )),
      ]),

      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(children: [
          Expanded(child: DarkContainer(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: Row(children: [
                Expanded(
                  child: Text(_selectedDate.formated, style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800
                  )),
                ),

                Image.asset(CalendarIcon, width: 25)
              ]),

              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: _firstDate,
                  lastDate: _lastDate
                );

                if (date != null) {
                  setState(() => _selectedDate = date);
                  widget.onDateChanged(_selectedDate);
                }
              }
            )
          )),
          SizedBox(width: 15),
          Expanded(child: DarkContainer(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10
            ),
            child: DropdownButtonFormField(
              hint: Text('Select Time'),
              isDense: true,
              value: _selectedTimeSlot,
              decoration: InputDecoration(
                border: InputBorder.none
              ),
              style: TextStyle(
                fontSize: 14, color: Colors.grey.shade800
              ),
              icon: Image.asset(ClockIcon),
              onChanged: (value) {
                widget.onTimeChanged(value);
              },
              items: _intervals.map((e) {
                return DropdownMenuItem(
                  child: Text(e.toString()),
                  value: e,
                );
              }).toList()
            )
          ))
        ]),
      ),
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }
}
