import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/rest/haweyati-service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final String previousImage;
  final Function (String) onImagePicked;
  ProfileImagePicker({this.previousImage,this.onImagePicked});
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  PickedFile pickedImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Stack(fit: StackFit.loose, children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).accentColor,width: 2)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: pickedImage == null
                    ? widget.previousImage!=null
                    ? Image.network(HaweyatiService.convertImgUrl(widget.previousImage),fit: BoxFit.cover,)
                    : Icon(
                  CupertinoIcons.person_solid,
                  color: Colors.blue,
                  size: 55,
                )
                    : Image.file(File(pickedImage.path),fit: BoxFit.cover,),
              ),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.only(top: 60.0, left: 86.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final image = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
                    if(image!=null){
                      setState(() {
                        this.pickedImage = image;
                      });
                      widget.onImagePicked(image.path);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    height: 35,
                    width: 35,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
