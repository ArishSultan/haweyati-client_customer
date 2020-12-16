import 'package:share/share.dart';
import 'package:haweyati/src/services/dynamic-links_service.dart';
import 'package:haweyati/src/ui/modals/dialogs/waiting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:haweyati/src/ui/views/no-scroll_view.dart';
import 'package:haweyati/src/ui/views/dotted-background_view.dart';
import 'package:haweyati_client_data_models/models/shareable-data_model.dart';

class ProductDetailView extends StatelessWidget {
  final String image;
  final String title;
  final Widget bottom;
  final TextSpan price;
  final String shareLink;
  final String description;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ShareableData shareableData;

  ProductDetailView({
    this.image,
    this.title,
    this.price,
    this.bottom,
    this.shareLink,
    this.description,
    this.shareableData,
  });

  @override
  Widget build(BuildContext context) {
    return NoScrollView(
      key: _scaffoldKey,
      appBar: HaweyatiAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => WaitingDialog(message: 'Preparing to share',)
              );
              final link = await DynamicLinksService.createDynamicLink(
                  queryParameters: {
                    'id': shareableData.id,
                    'city': AppData().city
                  },
                  path: 'products/${shareableData.type.link}',
                  socialMediaTitle: shareableData.socialMediaTitle,
                  socialMediaDescription: shareableData.socialMediaDescription
              ).buildShortLink();
              print(link.shortUrl);
              print(link.warnings);
              Navigator.of(context).pop();
              Share.share(link.shortUrl.toString(), subject: 'Check this out!');
            },
          )
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF313F53),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: RichText(text: price),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                description ?? '',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ),
      ),
      extendBody: true,
      bottom: bottom,
    );
  }
}

extension ExOrderTypeLink on OrderType {
  String get link {
    switch (this) {
      case OrderType.dumpster: return 'dumpsters';
      case OrderType.finishingMaterial: return 'finishing-materials';
      case OrderType.scaffolding: return 'scaffoldings';
      case OrderType.buildingMaterial: return 'building-materials';
    }

    return '';
  }
}
