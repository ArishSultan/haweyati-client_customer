import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/buttons/flat-action-button.dart';
import 'package:haweyati/src/ui/widgets/text-fields/text-field.dart';
import 'package:haweyati/src/utils/lazy_task.dart';
import 'package:haweyati/src/utils/validations.dart';
import 'package:haweyati_client_data_models/data.dart';

class RatingBottomSheet extends StatefulWidget {
  final Order order;
  RatingBottomSheet(this.order);
  @override
  _RatingBottomSheetState createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {

  double _supplierRating = 5;
  double _driverRating = 5;
  TextEditingController driverReview = TextEditingController();
  TextEditingController supplierReview = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15))),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("How was your experience?",style: TextStyle(color: Color(0xFF313F53),
                              fontWeight: FontWeight.bold,fontSize: 15),),
                        ),
                        FlatButton(
                          splashColor: Colors.grey.shade200,
                          child: Text("Cancel",style: TextStyle(color: Color(0xFF313F53)),),
                          onPressed: ()=> Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                 if(widget.order.supplier!=null) _tile(name: widget.order.supplier?.person?.name,
                     image:widget.order.supplier?.person?.image?.name ,rating: _supplierRating,onRatingChanged: (double rating){
                        setState(() {
                          _supplierRating = rating;
                        });
                     }),

                  if(widget.order.supplier!=null)   Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: HaweyatiTextField(
                      label: 'Supplier Review',
                      lines: 2,
                      controller: supplierReview,
                      validator: (val)=> emptyValidator(val, "Supplier Review"),
                    ),
                  ),

                  if(widget.order.driver!=null) _tile(name: widget.order.driver?.profile?.name,
                      image:widget.order.driver?.profile?.image?.name ,rating: _driverRating,onRatingChanged: (double rating){
                        setState(() {
                          _driverRating = rating;
                        });
                      }),
                  if(widget.order.driver!=null)  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: HaweyatiTextField(
                      label: 'Driver Review',
                      lines: 2,
                      controller: driverReview,
                      validator: (val)=> emptyValidator(val, "Driver Review"),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 40.0),
                    child: FlatActionButton(
                      icon: Icon(CupertinoIcons.checkmark_circle),
                      label: 'SUBMIT',
                      onPressed: () async{
                        if(formKey.currentState.validate()){
                          await performLazyTask(context,() async {
                            var _data = {
                              "_id" : widget.order.id,
                              "driverRating" : _driverRating,
                              "supplierRating" : _supplierRating,
                              "supplierReview" : supplierReview.text,
                              "driverReview" : driverReview.text,
                            };
                            if(widget.order.type == OrderType.deliveryVehicle) {
                              _data.remove("supplierRating");
                              _data.remove("supplierReview");
                            }
                            await HaweyatiService.patch("orders/rate", _data);
                          },message: 'Rating');
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            autoValidate = AutovalidateMode.always;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _tile({String image,String name,double rating,Function(double) onRatingChanged}){
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: image == null ?
        AssetImage("assets/images/haweyati_logo.png") :
        NetworkImage(image ,scale: 2),
      ),
      subtitle: StarRating(
        padding: EdgeInsets.zero,
        starCount: 5,
        size: 30,
        rating: rating,
        onRatingChanged:onRatingChanged,
      ),
      title: Text(name,style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }

}


typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;

  StarRating({
    this.starCount = 5, this.rating = .0, this.onRatingChanged,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.color,this.size=35,
    this.padding = const EdgeInsets.all(20)});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        size: size,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: new List.generate(starCount, (index) => buildStar(context, index))),
    );
  }
}