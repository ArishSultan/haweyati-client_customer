import 'package:flutter/material.dart';
import 'package:haweyati/services/time-slots_service.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';

class OrderTimePicker extends StatefulWidget {
  final index;
  final Function(String) onIntervalChange;
  OrderTimePicker({this.onIntervalChange,this.index});
  @override
  _OrderTimePickerState createState() => _OrderTimePickerState();
}

class _OrderTimePickerState extends State<OrderTimePicker> {
  Future<List<String>> timeSlots;
  static List<String> timeIntervals = ['6:00am-9:00am', '9:00am-12:00pm' ,'12:pm-3:00pm', '6:00pm-9:00pm', '9:00pm-12:00am'];
  String selectedInterval = timeIntervals[0];

  @override
  void initState() {
    super.initState();

    widget.onIntervalChange(selectedInterval);
  }

  Future<List<String>> fetchTimeSlots([bool flag=true]) async {
    timeSlots = TimeSlotsService().getAvailableTimeSlots(0,flag);
    timeSlots.then((value) {
      selectedInterval = value[0];
    });
    return timeSlots;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color:Color(0xfff2f2f2f2),
            borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          SimpleFutureBuilder.simpler(
            context : context,
            future: timeSlots,
            builder: (AsyncSnapshot<List<String>> timeSlots){
              return DropdownButton<String>(
                underline: SizedBox(),
                value: selectedInterval,
                items: timeSlots.data.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left:14.0),
                      child: Text('$value', textAlign: TextAlign.center),
                    ),
                  );
                }).toList(),
                onChanged: (_) {
                  setState(() {
                    selectedInterval = _;
                    widget.onIntervalChange(_);
                  });
                },
              );
            },
          ),
        ],)
    );
  }
}
