import 'package:flutter/material.dart';
import 'package:haweyati/src/common/services/easy-rest/easy-rest.dart';
import 'package:haweyati/src/common/services/http/basics/http-utils.dart';
import 'package:haweyati/src/common/services/http/basics/request-type.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();

    EasyRest.configure(
      port: 4000,
      host: '192.168.100.100',
      scheme: 'http'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        RaisedButton(
          onPressed: () async {
            print(await EasyRest(endpoint: 'customers').$getAll(route: 'getAll'));
            // final val = await request(
            //   uri: Uri(
            //     port: 4000,
            //     host: '192.168.100.100',
            //     scheme: 'http',
            //     path: 'suppliers'
            //   ),
            //   // data: 123,
            //   type: RequestType.get
            // );
            //
            // print(val.statusCode);
            // print(val.data);
          },
          child: Text('test'),
        )
      ]),
    );
  }
}
