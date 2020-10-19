import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final dynamic data;
  TestPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(data?.toString() ?? 'No DATA', style: TextStyle(color: Colors.white)),
    );
  }
}
