import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DarkListTile extends Container {
  DarkListTile({
    String title,
    Widget trailing,
    Function onTap
  }): super(
    decoration: BoxDecoration(
      color: Color(0xfff2f2f2f2),
      borderRadius: BorderRadius.circular(8),
    ),

    child: GestureDetector(
      onTap: onTap,
      child: ListTile(
        dense: true,
        title: Text(title, style: TextStyle(
          fontFamily: 'Helvetica'
        )),
        trailing: trailing,
      ),
    )
  );
}