import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/widgets/dark-container.dart';
import 'package:haweyati/src/ui/widgets/buttons/edit-button.dart';

class OrderConfirmationItem extends StatelessWidget {
  final String title;
  final String image;
  final Table table;
  final bool assetImage;

  OrderConfirmationItem({
    this.title,
    this.image,
    this.table,
    this.assetImage=false,
  });

  @override
  Widget build(BuildContext context) {
    return DarkContainer(
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 15),
      child: Column(children: [
        Row(children: [
          Text(
            'Service Details',
            style: TextStyle(
              color: Color(0xFF313F53),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          EditButton(onPressed: () {
            Navigator.of(context)..pop()..pop();
          }),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
           assetImage ? Image.asset(image, height: 60,width: 60,) : Image.network(HaweyatiService.resolveImage(image), height: 60,width: 60,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF313F53),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: table,
        ),
      ]),
    );
  }
}
