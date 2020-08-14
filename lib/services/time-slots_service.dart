import 'package:haweyati/models/hive-models/time-slots.dart';
import 'package:haweyati/services/haweyati-service.dart';

class TimeSlotsService extends HaweyatiService<TimeSlot> {
  @override
  TimeSlot parse(Map<String, dynamic> item) => TimeSlot.fromJson(item);

  Future<List<TimeSlot>> _getTimeSlots() {
    return this.getAll('time-slots');
  }

  Future<List<String>> getAvailableTimeSlots(int index,[bool flag=true]) async {
    List<TimeSlot> slots  = await _getTimeSlots();
    TimeSlot slot = slots[index];
    List<String> timeIntervals = _generateTimeSlots(slot,flag).cast<String>();
    return timeIntervals;
  }

  _generateTimeSlots(TimeSlot slot, [bool flag = true]) {
    final current = flag ? DateTime.now().hour : 0;
    final to = _parseSlot(slot.to);
    final from = _parseSlot(slot.from);

    if (current < from && current > to) {
      return [];
    }

    final arr = [];

    for (var i = from; i < to; i += 3) {
      var next = i + 3;

      if (next > to) {
        next = to;
      }

      if (current < next)
        arr.add( "$i:00 to $next:00");
    }

    print(arr);

    return arr;
  }

  _parseSlot(String time) {
    return int.parse(time.split(':')[0]);
  }

}