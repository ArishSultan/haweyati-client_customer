import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final PickedFile initialImage;
  final Function(PickedFile) onImagePicked;

  ImagePickerWidget({this.initialImage, this.onImagePicked});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  PickedFile _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff2f2f2f2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            FlatButton(
              child: Text('Camera'),
              shape: StadiumBorder(),
              textColor: Colors.white,
              color: Theme.of(context).accentColor,
              onPressed: () async {
                final image = await ImagePicker().getImage(source: ImageSource.camera);
                if (image != null) setState(() => this._image = image);
              }
            ),
            FlatButton(
              child: Text('Gallery'),
              shape: StadiumBorder(),
              textColor: Colors.white,
              color: Theme.of(context).accentColor,
              onPressed: () async {
                final image = await ImagePicker().getImage(source: ImageSource.gallery);
                if (image != null) setState(() => _image = image);

                widget.onImagePicked(_image);
              },
            )
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 200,
              child: _resolveImage(),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _resolveImage() {
    if (_image == null) {
      return Center(
        child: Text('No Image Selected', style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold
        ))
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(File(_image.path))
          )
        ),
        child: Center(
          child: _image == null ? Text('No Image is Selected', style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic
          )): Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(_image.path))
              )
          ),
          child: Align(
            alignment: Alignment(.95, -.95),
            child: SizedBox(
              width: 35,
              height: 35,
              child: FlatButton(
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.delete, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed: () => setState(() => _image = null)
              ),
            ),
          ),
        )
      ));
    }
  }
}