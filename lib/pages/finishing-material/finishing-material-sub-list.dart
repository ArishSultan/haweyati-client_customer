import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haweyati/models/finishing-material_category.dart';
import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/services/fn-sublist_service.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utlis/const.dart';
import 'package:haweyati/src/utlis/simple-future-builder.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/widgits/custom-navigator.dart';
import 'package:haweyati/widgits/haweyati_Textfield.dart';
import 'package:haweyati/widgits/list-of-items.dart';

import 'finishing_material_detail.dart';

class FinishingMaterialSubList extends StatefulWidget {
 final FinishingMaterial material;
 FinishingMaterialSubList({this.material});
  @override
  _FinishingMaterialSubListState createState() =>
      _FinishingMaterialSubListState();
}

class _FinishingMaterialSubListState extends State<FinishingMaterialSubList> {


  Future<List<FinProduct>> sublist;
  bool showSearch = false;
  int productsLength;
  var _service = FINSublistService();
  var searchKeyword = TextEditingController();

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
      content: Text("Server is Required for Performing this Function"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  performSearch(){
    setState(() {
      sublist = _service.search(searchKeyword.text);
    });
  }

  refresh(){
    setState(() {
      sublist = _service.getFinSublist(widget.material.sId);
    });
  }


  @override
  void initState() {
    super.initState();
    sublist = _service.getFinSublist(widget.material.sId);
    sublist.then((value) {
      setState(() {
        productsLength = value.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2f2),
      appBar: HaweyatiAppBar(context: context,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(HaweyatiService.convertImgUrl(widget.material.image.name))), ),
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.material.name,
                  textAlign: TextAlign.center,
                  style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          showSearch ?  Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    placeholder: 'Search..',
                    textInputAction: TextInputAction.search,
                    suffix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.search,color: Colors.grey,),
                    ),
                    onSubmitted: (String val){
                      if(val.isNotEmpty){
                        setState(() {
                          performSearch();
                        });
                      }
                    },
                    controller: searchKeyword,
//                    validator: (value){
//                      return value.isEmpty ? 'Please enter some keyword to search' : null;
//                    },
                  ),
                ),
              IconButton(
              onPressed: (){
                setState(() {
                  refresh();
                  showSearch=false;
                });
                },
              icon: Icon(CupertinoIcons.clear_circled_solid),
              )
              ],
            ) :
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: productsLength !=null ? Text(
                      productsLength!= 0?
                      "$productsLength items available" : 'No items available',
                      style: boldText,
                    ): SizedBox()),
//                _build(imgPath: "assets/images/grid.png", onTap: () {showAlertDialog(context);}),
                _build(imgPath: "assets/images/search.png", onTap: () {
                  setState(() {
                    showSearch=true;
                  });
                })
              ],
            ),
            Expanded(
                child: SimpleFutureBuilder.simpler(
                  context: context,
                  future: sublist,
                  builder: (AsyncSnapshot<List<FinProduct>> snapshot){
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (build,i){
                        var item = snapshot.data[i];
                        return  ContainerDetailList(
                          imgpath: item.images.name,
                          name: item.name,
                          ontap:  () {
                            CustomNavigator.navigateTo(context, FinishingMaterialDetail(finishingMaterial: item));
                            },
                        );
                      },

                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget _build({String imgPath, Function onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Image.asset(imgPath),
    );
  }
}
