import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/pages/drawer/setting/edit-profile.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utlis/hive-local-data.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print(HaweyatiData.customer.profile.image);
    return Scaffold(
      appBar:HaweyatiAppBar(showHome: false,showCart: false,),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Stack(
                      children: <Widget>[
                    Column(
                        children: <Widget>[
                       Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 3),
                          shape: BoxShape.circle
                       ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: HaweyatiData.customer?.profile?.image?.name !=null ? NetworkImage(HaweyatiService.convertImgUrl(HaweyatiData.customer.profile.image.name ))  : AssetImage("assets/images/dumpsterhome.png"),
                              ),
                            ),
                            SizedBox(height: 10,),

                          ],
                        ),
//                        Positioned(
//                          bottom: 8,
//                          right: 0,
//                            child: MaterialButton(
//                              minWidth: 30,
//                              shape: CircleBorder(),
//                                color: Colors.white,
//                                padding: EdgeInsets.all(0),
//                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                              child: Icon(Icons.camera_alt,color: Colors.black,size: 16,),onPressed: (){},))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Text(HaweyatiData.customer.profile.name,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16)),
                HaweyatiData.customer.status == 'Blocked' ?_profileTile(title:  "${HaweyatiData.customer.status} (${HaweyatiData.customer.message})",icon: Icons.block,color: Colors.redAccent) : SizedBox(),
                SizedBox(height: 10,),
                Divider(thickness:1.5,),
                Text("Personal Details",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16)),

                _profileTile(title: HaweyatiData.customer.profile.username,icon: Icons.call,color: Colors.green),
                _profileTile(title:  HaweyatiData.customer.profile.email,icon: Icons.email,color: Colors.purple),
                _profileTile(title:  HaweyatiData.customer.location.address,icon: Icons.pin_drop,color: Colors.redAccent),
//               HaweyatiData.customer.status == 'Blocked' ? _profileTile(title:  HaweyatiData.customer.message,icon: Icons.pin_drop,color: Colors.redAccent) : SizedBox(),

              ],
            ),
          ),

        ],
      ),
      floatingActionButton:FloatingActionButton ( onPressed: () async {await CustomNavigator.navigateTo(context,EditProfile());
      setState(() {

      });},
        child: Icon(Icons.edit,color: Colors.white,),) ,
    );
  }

  Widget _profileTile({IconData icon,String title,Color color,String subtitle}){
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon,color: Colors.white,),
      ),
      title: Text(title,style: TextStyle(fontSize: 15),),
    );
  }
}
