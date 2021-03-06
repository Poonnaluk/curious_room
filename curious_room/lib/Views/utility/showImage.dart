import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImageScreen extends StatefulWidget {
  ImageScreen({Key? key, required this.uri}) : super(key: key);
  dynamic uri;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2,
                imageProvider: checkType(widget.uri),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  checkType(dynamic image) {
    if (widget.uri.runtimeType.toString() == "_File") {
      return FileImage(widget.uri);
    } else {
      return NetworkImage(
        widget.uri.toString(),
      );
    }
  }
}
