import 'package:flutter/cupertino.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  static DynamicLinkParameters createDynamicLink({
    String path,
    String socialMediaTitle,
    String socialMediaDescription,
    Map<String, dynamic> queryParameters,
  }) {
    return DynamicLinkParameters(
      uriPrefix: 'https://haweyatiapp.page.link/',
      link: Uri(
        port: 443,
        path: path,
        scheme: 'https',
        host: 'haweyatiapp',
        queryParameters: queryParameters
      ),

      androidParameters: AndroidParameters(
        packageName: 'com.example.haweyati',
        minimumVersion: 125,
      ),
      // TODO: Uncomment these.
      // iosParameters: IosParameters(
      //   bundleId: 'com.example.ios',
      //   minimumVersion: '1.0.1',
      //   appStoreId: '123456789',
      // ),
      // googleAnalyticsParameters: GoogleAnalyticsParameters(
      //   campaign: 'haweyati',
      //   medium: 'social',
      //   source: 'orkut',
      // ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: socialMediaTitle,
        description: socialMediaDescription,
      ),
    );
  }

  static void initiate(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (data) async {
        print('Dynamic Link');
        print(data.link.path);
        print(data.link.fragment);
        print(data.link.queryParametersAll);
      },

      onError: (error) async {
        print('onLinkError');
        print(error.stacktrace);
      }
    );

    /// Handle Pending Link;
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    print(data.link);
    print(data.link.path);
  }
}