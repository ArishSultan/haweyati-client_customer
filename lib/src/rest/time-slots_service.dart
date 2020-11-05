import 'package:haweyati/src/models/order/order-type.dart';
import 'package:haweyati/src/models/time-slot_model.dart';

import 'haweyati-service.dart';

class TimeSlotsService extends HaweyatiService<TimeSlot> {
  @override
  TimeSlot parse(Map<String, dynamic> item) => TimeSlot.fromJson(item);

  Future<TimeSlot> $getTimeSlotOf(OrderType type) async {
    return (await getAll('time-slots'))[type.index];
  }

  Future<TimeSlot> getTimeSlotsOf(ServiceType type) async {
    return (await getAll('time-slots'))[type.index];
  }
}

///
/// @RestService()
/// abstract class _TimeSlotsService {
///   @Get('time-slots')
///   Future<List<TimeSlot>> _getTimeSlots();
///
///   List<TimeSlot> getTimeSlotsOf(OrderType type) async {
///     return (await _getTimeSlots())[type.index];
///   }
/// }
///