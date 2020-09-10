import 'package:flutter/material.dart';
import 'package:haweyati/models/finishing-product.dart';
import 'package:haweyati/models/hive-models/orders/finishing-material_order.dart';
import 'package:haweyati/models/options_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/widgits/appBar.dart';
import 'package:haweyati/src/utils/custom-navigator.dart';
import 'package:haweyati/widgits/round-drop-down-button.dart';
import 'package:hive/hive.dart';

import 'finishing-order-confirmation.dart';

class TransformedOption{
  String name;
  List<String> values;
  TransformedOption({this.name,this.values});
}
class FinishingMaterialDetail extends StatefulWidget {
  final FinProduct finishingMaterial;
  FinishingMaterialDetail({this.finishingMaterial});
  @override
  _FinishingMaterialDetailState createState() => _FinishingMaterialDetailState();
}

class _FinishingMaterialDetailState extends State<FinishingMaterialDetail> {
  String selectedVal;
  String selectedVal1;
  String selectedVal2;
  Map<String, dynamic> selected = {};
  List<TransformedOption> transformedOptions = [];
  double price;
  FMOrder order;

  FinProduct finishingProduct;
  List<ProductOption> options;

  @override
  void initState() {
    super.initState();
    finishingProduct = widget.finishingMaterial;
    options = widget.finishingMaterial.options;
    getVariants();
  }

  void orderFM(FMOrder order) async {
    final box = await Hive.openBox('finishing-material-order');
    await box.clear();
    box.add(order);
    order.save();
  }



  getVariants(){
    if(options.isNotEmpty){
      for(var i=0; i<options.length; ++i)
      {
        transformedOptions.add(TransformedOption(
          name: options[i].optionName,
          values: options[i].optionValues.split(',')
        ));
        selected[options[i].optionName] = options[i].optionValues.split(',').first;
        _calculatePrice();
        print(transformedOptions[i].name);
        print(transformedOptions[i].values);
      }
    } else {

      price = finishingProduct.price;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xffffffff),
        appBar: HaweyatiAppBar(context: context,),
        body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: (
                          Image.network(HaweyatiService.convertImgUrl(widget.finishingMaterial.images.name),fit: BoxFit.cover,)
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                     widget.finishingMaterial.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          price.toString() + " SR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.finishingMaterial.description,
                      style: TextStyle(color: Colors.black54),),
                    SizedBox(
                      height: 20,
                    ),
                      Wrap(
                        spacing: 50,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for(var tOption in transformedOptions)
                            variantDropDown(tOption),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),



              Align(alignment: Alignment(0, 0.9), child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: _buildButton("Add to Cart", (){
                    })),
                    Expanded(flex: 1,
                        child: _buildButton("Buy Now", () async {
                          await orderFM(FMOrder(
                            product: finishingProduct,
                            price: price,
                            qty: 2,
                            total: price * 2,
                            variant: selected,
                          ));
                          CustomNavigator.navigateTo(context, FinishingOrderConfirmation(product: finishingProduct,));
                        }))
                  ],
                ),
              )
                ,)
            ])
    );
  }

  void _calculatePrice() {

    for (final variant in widget.finishingMaterial.variants) {
      var match = true;

      for (final key in selected.keys) {
        if (selected[key] != variant[key]) {
          match = false;
          break;
        }

      }

      if (match) {

        print('Price is ${variant['price']}');
        setState(() {
          price = double.parse(variant['price']);
        });

        return;
      }
    }
  }


  Widget _buildButton(String buttonName ,Function onTap ){return
    Align(
    alignment: Alignment(0, 0.98),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap:onTap ,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).accentColor),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  ); }

  Widget variantDropDown(TransformedOption option){
    return Column(
      children: [
        Text(option.name,style: TextStyle(fontWeight: FontWeight.bold),),
//        for(var value in option.values)
//          Text(value,style: TextStyle(fontWeight: FontWeight.bold),),

        SizedBox(
          width: 100,
          child: RoundDropDownButton<String>(
            items: option.values
                .map((i) => DropdownMenuItem<String>(
                child: Text(i), value: i))
                .toList(),
            value: option.values.first,
            onChanged: (item) => setState(() {
              selected[option.name] = item;
              _calculatePrice();
              FocusScope.of(context).requestFocus(FocusNode());
            }),
          ),
        ),
      ],
    );
  }

//  Widget variantDropDown(TransformedOption option){
//    return Column(
//      children: [
//        Text(option.name,style: TextStyle(fontWeight: FontWeight.bold),),
//        SizedBox(
//          width: 100,
//          child: RoundDropDownButton<String>(
//            items: option.values
//                .map((i) => DropdownMenuItem<String>(
//                child: Text(i), value: i))
//                .toList(),
//            value: option.values.first,
//            onChanged: (item) => setState(() {
//              selected[option.name] = item;
//              _calculatePrice();
//              FocusScope.of(context).requestFocus(FocusNode());
//            }),
//          ),
//        ),
//      ],
//    );
//  }

}