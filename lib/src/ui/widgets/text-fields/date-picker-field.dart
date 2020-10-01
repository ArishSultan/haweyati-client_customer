import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';

class DatePickerField extends StatefulWidget {
  final DatePickerMode mode;
  final DateTime initialValue;
  final void Function(DateTime date) onChanged;

  DatePickerField({
    this.mode,
    this.initialValue,
    @required this.onChanged
  });

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
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
    _selectedDate = widget.initialValue ?? _firstDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(children: [
        Expanded(child: Text(_parse(_selectedDate), style: TextStyle(
          fontFamily: 'Lato'
        ))),
        Image.asset(CalendarIcon, width: 24)
      ]),

      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDatePickerMode: widget.mode,
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
