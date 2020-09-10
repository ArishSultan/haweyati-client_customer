import 'package:haweyati/src/models/time-slot_model.dart';
import 'package:haweyati/services/haweyati-service.dart';


enum ServiceType {
  delivery_vehicles,
  dumpsters,
  finishing_materials,
  building_materials,
  scaffoldings,
}

class TimeSlotsService extends HaweyatiService<TimeSlot> {
  @override
  TimeSlot parse(Map<String, dynamic> item) => TimeSlot.fromJson(item);

  Future<TimeSlot> getTimeSlotsOf(ServiceType service) async {
    return (await getAll('time-slots'))[service.index];
  }
}
