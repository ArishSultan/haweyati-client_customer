import 'package:hive/hive.dart';
import '../../../src/models/image_model.dart';
import 'package:haweyati/src/common/models/json_serializable.dart';


@HiveType(typeId: 101)
class Profile extends HiveObject implements JsonSerializable {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String email;
  @HiveField(3) String contact;
  @HiveField(4) String username;
  @HiveField(6) String password;

  @HiveField(5) bool isVerified;
  @HiveField(7) ImageModel image;
  @HiveField(8) List<String> scope;

  Profile.fromJson(Map<String,dynamic> json){
    print("Received json $json");

    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    contact = json['contact'];
    image = json['image']!=null ? ImageModel.fromJson(json['image']) : null;
    username = json['username'];
    isVerified = json['isVerified'];
    scope = json['scope'].cast<String>();
  }

  @override
  Map<String, dynamic> serialize() => {
    '_id': id,
    'name': name,
    'email': email,
    'scope': scope,
    'image': image?.serialize(),
    'contact': contact,
    'username': username,
    'password': password,
    'isVerified': isVerified,
  };
}
// import 'package:hive/hive.dart';
//
// import '../../image_model.dart';
// import '../../image_model.dart';
// part 'profile_model.g.dart';
//
// @HiveType(typeId: 9)
// class Profile extends HiveObject{
//   @HiveField(0)
//   String id;
//   @HiveField(1)
//   String name;
// //  @HiveField(2)
// //  String email;
//   @HiveField(3)
//   String contact;
//   @HiveField(4)
//   String username;
//   @HiveField(5)
//   List<String> scope;
//   @HiveField(6)
//   bool isVerified;
//   @HiveField(7)
//   String password;
//   @HiveField(8)
//   Images image;
//
//   Profile({this.id,this.contact,this.username,this.scope,this.isVerified,this.name,this.password,this.image});
//

//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (this.id != null) {
//       data['_id'] = this.id;
//     }
//     if (this.isVerified != null) {
//       data['isVerified'] = this.isVerified;
//     }
//     data['scope'] = this.scope!=null ? this.scope[0] : null;
// //    data['email'] = this.email;
//     data['image'] = this.image?.toJson();
//     data['contact'] = this.contact;
//     data['name'] = this.name;
// //    data['password'] = this.password;
//     data['username'] = this.username;
//     return data;
//   }
//
// }