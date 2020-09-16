import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/flat-action-button.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';

class ServiceItemView extends NoScrollView {
  final String image;
  final String title;
  final Widget bottom;
  final TextSpan price;
  final String description;


  ServiceItemView({
    this.image,
    this.title,
    this.price,
    this.bottom,
    this.description
  }): super(
    appBar: HaweyatiAppBar(),
    body: DottedBackgroundView(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(children: [
          SizedBox(
            height: 250,
            child: Center(
              child: Image.network(
                HaweyatiService.resolveImage(image),
                height: 250,
              ),
            )
          ),

          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Text(title, style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20
              ))
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: RichText(text: price),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(description ?? '', style: TextStyle(color: Colors.grey.shade600)),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start)
      )
    ),
    extendBody: true,
    bottom: bottom
  );
}
