import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Row themeMoreButton(String image, String name,double sc) {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.all(14),
        child: Image.asset(
          image,
          scale: sc,
        ),
      ),
      Text(name,
          style:
              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.6), fontSize: 20.sp)),
    ],
  );
}
