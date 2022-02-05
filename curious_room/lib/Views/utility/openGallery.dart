import 'dart:io';
import 'package:curious_room/Views/Style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future chooseImage() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    return imageTemporary;
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}

cropImage(BuildContext context, File _image) async {
  File? cropped = await ImageCropper.cropImage(
      sourcePath: _image.path,
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: grayColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          hideBottomControls: true,
          lockAspectRatio: true));
  dynamic img = cropped;
  return img;
}
