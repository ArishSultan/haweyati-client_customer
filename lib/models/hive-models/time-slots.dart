import 'package:hive/hive.dart';
part 'time-slots.g.dart';

@HiveType(typeId: 3)
class TimeSlot extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String category;
  @HiveField(2)
  String from;
  @HiveField(3)
  String to;

  TimeSlot({this.from,this.category,this.id,this.to});

  TimeSlot.fromJson(Map<String,dynamic> json){
    id = json['_id'];
    category = json['category'];
    from = json['from'];
    to = json['to'];
  }


  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['category'] = this.category;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}