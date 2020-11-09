import 'package:haweyati/src/const.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:retrofit/http.dart';

import '_config.dart';

part 'time-slots_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class _TimeSlotsRest {
  factory _TimeSlotsRest() => __TimeSlotsRest(defaultDio);

  @GET('/time-slots')
  Future<List<TimeSlot>> getTimeSlots();
}

class TimeSlotsRest {
  var _service = _TimeSlotsRest();

  Future<TimeSlot> getTimeSlotOf(OrderType type) async {
    return (await _service.getTimeSlots())[type.index];
  }
}