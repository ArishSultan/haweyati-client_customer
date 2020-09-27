import 'package:hive/hive.dart';

part 'options_model.g.dart';

@HiveType(typeId: 26)
class FinishingMaterialOption extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) List<String> values;

  FinishingMaterialOption({
    this.id,
    this.name,
    this.values,
  });

  factory FinishingMaterialOption.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FinishingMaterialOption(
      id: json['_id'],
      name: json['optionName'],
      values: json['optionValues'].split(','),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': this.id,
    'optionName': this.name,
    'optionValues': this.values
  };
}