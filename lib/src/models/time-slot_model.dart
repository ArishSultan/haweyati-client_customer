import 'package:flutter/material.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';

enum ServiceType {
  dumpsters,
  scaffoldings,
  delivery_vehicles,
  buildingMaterials,
  finishing_materials,
}

class TimeSlot implements JsonSerializable {
  final TimeOfDay to;
  final TimeOfDay from;

  TimeSlot({this.to, this.from});

  factory TimeSlot.fromJson(Map<String,dynamic> json) {
    final _to = json['to'].toString().split(':');
    final _from = json['from'].toString().split(':');

    return TimeSlot(
      to: TimeOfDay(hour: int.parse(_to[0]), minute: int.parse(_to[1])),
      from: TimeOfDay(hour: int.parse(_from[0]), minute: int.parse(_from[1]))
    );
  }

  List<TimeSlot> intervals(DateTime date) {
    TimeOfDay _current;

    if (date.day != DateTime.now().day) {
      _current = TimeOfDay.fromDateTime(date);
    } else {
      _current = TimeOfDay.fromDateTime(DateTime.now());
    }

    final _intervals = <TimeSlot>[];
    for (var i = from; i < to; i = i.increment(3)) {
      var next = i.increment(3);

      if (next > to) next = to;
      if (_current < next) _intervals.add(TimeSlot(
        from: i, to: next
      ));
    }

    return _intervals;
  }

  @override String toString() {
    return '${from.__toString()} - ${to.__toString()}';
  }

  @override Map<String, dynamic> serialize() => {
    'to': '${to.hour}:${to.minute}',
    'from': '${from.hour}:${from.minute}'
  };

  @override
  bool operator ==(Object other) {
    if (other is TimeSlot) {
      return to == other.to && from == other.from;
    }
    return false;
  }
}

extension Comparison on TimeOfDay {
  __toString() {
    final buffer = StringBuffer();

    buffer.write(hour % 12);
    if (minute > 0) {
      buffer.write(':');

      if (minute < 10) {
        buffer.write('0');
      }

      buffer.write(minute);
    }

    if (period == DayPeriod.am) {
      buffer.write(' AM');
    } else {
      buffer.write(' PM');
    }

    return buffer.toString();
  }

  bool operator <(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute < other.minute;
    }

    return false;
  }

  TimeOfDay increment(int hours) {
    return TimeOfDay(hour: hour + hours, minute: 0);
  }

  bool operator >(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute > other.minute;
    }

    return false;
  }
}
