import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/utils/const.dart';

class TimeSlotPickerField extends StatefulWidget {
  final DateTime date;
  final void Function(DateTime date) onChanged;
  
  TimeSlotPickerField({this.date, this.onChanged});

  @override
  _TimeSlotPickerFieldState createState() => _TimeSlotPickerFieldState();
}

class _TimeSlotPickerFieldState extends State<TimeSlotPickerField> {
  DateTime _selectedDate;
  final _lastDate = DateTime.now().add(Duration(days: 700));
  final _firstDate = DateTime.now().add(Duration(hours: 12));

  static const months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  _parse(final DateTime dateTime) {
    return '${dateTime.day} ${months[dateTime.month-1]} ${dateTime.year}';
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? _firstDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(children: [
        Expanded(child: Text(_parse(_selectedDate), style: TextStyle(
          fontFamily: 'Lato'
        ))),
        Image.asset(ClockIcon, width: 24)
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
          widget.onChanged(_selectedDate);
        }
      }
    );
  }
}
