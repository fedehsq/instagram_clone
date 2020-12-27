import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone/DisplayImage.dart';
import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

class AlbumImages extends StatefulWidget {
  final album;
  final images;
  final size;

  const AlbumImages({Key key, this.images, this.album, this.size}) : super(key: key);

  @override
  _AlbumImagesState createState() => _AlbumImagesState();
}

class _AlbumImagesState extends State<AlbumImages> {
  final _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
              widget.album + " (" + widget.size.toString() + ")"
          )
        ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            crossAxisCount: 3),
        itemCount: widget.images.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<Widget>(
              future: _getImageFromInternalStorage(widget.images, index),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  _images.add(snapshot.data);
                  return snapshot.data;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
          );
        },
      )
    );
  }

  // read images from phone
  Future<Widget> _getImageFromInternalStorage(List<AssetEntity> imageList, int index) async {
    File file = await imageList[index].file;
    if (file.path.endsWith("jpg") || file.path.endsWith("jpeg") ||
        file.path.endsWith("png")) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DisplayImage(
                      image: FileImage(
                          file
                      )
                  )
          ));
        },
        child: Image(fit: BoxFit.fitWidth,
            image: ResizeImage(
                FileImage(
                    file
                ),
                width: 250, allowUpscaling: false
            )
        ),
      );
    } else {
      return Container(
          color: Colors.red,
          child: Center(
              child: Text(
                  "Not an Image!"
              )
          )
      );
    }
  }
}
