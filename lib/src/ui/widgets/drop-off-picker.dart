import 'package:flutter/material.dart';
import 'package:haweyati/src/const.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/utils/formats.dart';
import 'package:haweyati/src/rest/_new/time-slots_rest.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';

class DropOffPicker extends StatefulWidget {
  final Order order;
  final Function onReady;
  DropOffPicker(this.order, this.onReady);

  @override
  _DropOffPickerState createState() => _DropOffPickerState();
}

class _DropOffPickerState extends State<DropOffPicker> {
  TimeSlot _slot;
  DateTime _lastDate;
  DateTime _firstDate;
  List<TimeSlot> _intervals;

  Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = _prepareFirstBuild();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 81,
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: snapshot.connectionState == ConnectionState.done
                ? (_intervals != null ? _loadedChildren : _errorChildren)
                : _loadingChildren,
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        },
      ),
    );
  }

  List<Widget> get _loadingChildren => <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: _Title('Drop-off Details'),
        ),
        Expanded(
          child: DarkContainer(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Expanded(child: Text('Calculating Available Time Slots')),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            ]),
          ),
        ),
      ];

  List<Widget> get _errorChildren => <Widget>[
    Padding(
      padding: const EdgeInsets.only(left: 11),
      child: _Title('Drop-off Details'),
    ),
    Expanded(
      child: DarkContainer(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text('No Timeslot available'),
          ],
        ),
      ),
    ),
  ];

  List<Widget> get _loadedChildren => <Widget>[
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 11),
              child: _Title('Drop-off Date'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 17),
              child: _Title('Drop-off Time'),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(children: [
            Expanded(
              child: DarkContainer(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        widget.order.location.dropOffDate.formatted,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Image.asset(CalendarIcon, width: 25),
                  ]),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      lastDate: _lastDate,
                      firstDate: _firstDate,
                      initialDate: widget.order.location.dropOffDate,
                    );

                    if (date != null) {
                      setState(() {
                        widget.order.location.dropOffDate = date;

                        _intervals = _slot.intervals(date);
                        if (_intervals.isNotEmpty) {
                          widget.order.location.dropOffTime = _intervals.first;
                        }
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: DarkContainer(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: DropdownButtonFormField(
                  hint: Text('Select Time'),
                  isDense: true,
                  value: widget.order.location.dropOffTime,
                  decoration: InputDecoration(border: InputBorder.none),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  icon: Image.asset(ClockIcon),
                  onChanged: (value) {
                    widget.order.location.dropOffTime = value;
                  },
                  items: _intervals
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e.toString()),
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ]),
        ),
      ];

  _prepareFirstBuild() async {
    final _slot = await TimeSlotsRest().getTimeSlotOf(widget.order.type);
    final startTime = DateTime.now().add(Duration(hours: 12));

    print(_slot);

    _firstDate = TimeOfDay.fromDateTime(startTime) < _slot.to
        ? startTime
        : DateTime(
            startTime.year,
            startTime.month,
            startTime.day + 1,
            startTime.hour - 12,
          );
    _lastDate = _firstDate.add(Duration(hours: 200));

    if (widget.order.location?.dropOffDate != null) {
      if (widget.order.location.dropOffDate.isBefore(_firstDate)) {
        widget.order.location.dropOffDate = _firstDate;
      }
    } else {
      widget.order.location?.dropOffDate = _firstDate;
    }

    _intervals = _slot.intervals(widget.order.location.dropOffDate);
    print(_intervals);
    if (_intervals.isNotEmpty) {
      widget.order.location.dropOffTime ??= _intervals.first;
    }

    widget.onReady();
  }
}

class _Title extends Text {
  _Title(String title)
      : super(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        );
}
