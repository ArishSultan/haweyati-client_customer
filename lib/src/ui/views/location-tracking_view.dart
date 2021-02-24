import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati_client_data_models/data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveTrackingView extends StatefulWidget {
  final Order order;
  LiveTrackingView(this.order);
  @override
  LiveTrackingViewState createState() => LiveTrackingViewState();
}

class LiveTrackingViewState extends State<LiveTrackingView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.order.driver.profile.name,
          style: TextStyle(
        color: Colors.white
      ),),
      actions: [
        IconButton(icon: Icon(CupertinoIcons.phone), onPressed: () async {
          launch("tel:${widget.order.driver.profile.contact}");
        }),

      ],),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.order.shareUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
