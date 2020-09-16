import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/services/haweyati-service.dart';

class ServiceListItem extends StatelessWidget {
  final String name;
  final String image;
  final String detail;
  final Function onTap;
  final bool assetImage;

  ServiceListItem({
    this.image,
    this.detail,
    @required this.name,
    @required this.onTap,
    this.assetImage = false,
  }): assert(name != null),
      assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10, horizontal: 15
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.grey.shade300
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),

      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: this.assetImage ?
          Image.asset(image, width: 60):
          Image.network(HaweyatiService.resolveImage(image), width: 60),

        title: Text(name, style: TextStyle(fontFamily: 'Helvetica')),
        subtitle: detail != null
            ? Text(detail, style: TextStyle(color: Colors.grey))
            : null,
        trailing: Icon(CupertinoIcons.right_chevron),
      ),
    );
  }
}
