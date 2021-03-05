import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/_new/reviews_rest.dart';
import 'package:haweyati/src/ui/views/live-scrollable_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/src/ui/widgets/rate-bottom-sheet.dart';
import 'package:haweyati_client_data_models/models/order/driver_model.dart';
import 'package:haweyati_client_data_models/models/others/reviews_model.dart';
import 'package:haweyati_client_data_models/models/user/supplier_model.dart';
import 'package:intl/intl.dart';

class PersonReviews extends StatefulWidget {
  final Supplier supplier;
  final Driver driver;
  PersonReviews({this.supplier,this.driver});
  @override
  _PersonReviewsState createState() => _PersonReviewsState();
}

class _PersonReviewsState extends State<PersonReviews> {

  bool isSupplier = false;

  @override
  void initState() {
    super.initState();
    isSupplier = widget.supplier!=null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(),
      body: LiveScrollableView<Review>(
        loader:()=> isSupplier ? ReviewsRest().get(type: 'supplier', id: widget.supplier.id):
        ReviewsRest().get(type: 'driver', id: widget.driver.sId),
        builder: (context,Review review)=> ListTile(
          title: Text(isSupplier ? review.supplierFeedback :  review.driverFeedback),
          subtitle: StarRating(padding: EdgeInsets.zero,size: 20,
            rating: isSupplier ? review.supplierRating : review.driverRating,
          ),
          trailing: review.createdAt == null ?  SizedBox(): Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(review.createdAt),),
        ),
      ),
    );
  }
}
