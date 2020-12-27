import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatefulWidget {
  final image;

  const DisplayImage({Key key, this.image}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return Image(image: widget.image);
  }
}
