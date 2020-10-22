import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/services/haweyati-service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';

class ServiceItemView extends StatelessWidget {
  final String image;
  final String title;
  final Widget bottom;
  final TextSpan price;
  final String description;
  final String shareLink;
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ServiceItemView({
    this.image,
    this.title,
    this.price,
    this.bottom,
    this.description,
    this.shareLink
  });

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(
        actions: [
          IconButton(icon: Icon(Icons.share_outlined), onPressed: () {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Sharing will be available after purchasing application domain'
                  'i.e. https://www.haweyati.com'),
            ));
          })
        ],
      ),
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
                color: Color(0xFF313F53),
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
}
