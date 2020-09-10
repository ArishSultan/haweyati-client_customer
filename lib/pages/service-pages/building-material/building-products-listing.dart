import 'package:flutter/material.dart';
import 'package:haweyati/models/building-material_model.dart';
import 'package:haweyati/models/building-material_sublist.dart';
import 'package:haweyati/services/bm-sublist_service.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati-appbody.dart';
import 'package:haweyati/widgits/list-of-items.dart';

import 'building-product-detail.dart';

class BuildingMaterialSubList extends StatefulWidget {
  final BuildingMaterials buildingMaterials;
  BuildingMaterialSubList({this.buildingMaterials});
  @override
  _BuildingMaterialSubListState createState() =>
      _BuildingMaterialSubListState();
}

class _BuildingMaterialSubListState extends State<BuildingMaterialSubList> {

  Future<List<BMProduct>> bmSublist;
  var _service = BMSublistService();


  @override
  void initState() {
    super.initState();
    bmSublist =_service.getBMSublist(widget.buildingMaterials.sId);
    bmSublist.then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(context: context,),
      body: HaweyatiAppBody(
//          showButton: true,
//          onTap: () {},
//          btnName: "Buy Now",
          title:  'Building Material',
          detail: loremIpsum.substring(0, 90),
          child: SimpleFutureBuilder.simpler(
            future: bmSublist,
            context: context,
            builder: (AsyncSnapshot<List<BMProduct>> snapshot){
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: snapshot.data.length,
                itemBuilder: (context,i){
                  var bmSubList = snapshot.data[i];
                  return  ContainerDetailList(
                      name: bmSubList.name,
                      imgpath: bmSubList.image.name,
                      ontap: (){
                        CustomNavigator.navigateTo(context, BuildingDetail(item: bmSubList,));
                      }) ;
                },
              );
            },
          )
      ),
    );
  }
}