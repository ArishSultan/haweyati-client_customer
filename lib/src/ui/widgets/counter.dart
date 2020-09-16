import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double increment;

  final bool allowDouble;

  final double initialValue;
  final void Function(double count) onChange;

  Counter({
    this.increment = 1.0,
    this.allowDouble = false,
    this.minValue = 0,
    this.maxValue = null,
    this.initialValue = 0,
    @required this.onChange
  }): assert(onChange != null);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  double _count = 0;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue < widget.minValue) {
      _count = widget.minValue ;
    } else {
      _count = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      SizedBox(
        width: 23,
        height: 23,
        child: FlatButton(
          disabledColor: Color(0x7FFF974D),
          padding: const EdgeInsets.all(0),
          child: Icon(Icons.remove, color: Colors.white, size: 18),
          onPressed: _count > widget.minValue ? () {
            setState(() => _count -= widget.increment);
            widget.onChange(_count);
          } : null,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
        ),
      ),

      Container(
        width: 38,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Center(child: Text(
          widget.allowDouble ? _count.toString() : _count.round().toString(),
          style: TextStyle(
            fontFamily: 'Lato'
          ))
        ),
      ),

      SizedBox(
        width: 23,
        height: 23,
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          child: Icon(Icons.add, color: Colors.white, size: 18),
          onPressed: _count < (widget.maxValue ?? 1000) ? () {
            setState(() => _count += widget.increment);
            widget.onChange(_count);
          } : null,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
        ),
      )
    ], crossAxisAlignment: WrapCrossAlignment.center);
  }
}
