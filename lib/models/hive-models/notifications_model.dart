import 'package:hive/hive.dart';
part 'notifications_model.g.dart';

@HiveType(typeId: 5)
class Notifications extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;

  Notifications({this.title,this.description});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }

}