import 'package:flutter/material.dart';

screenw(BuildContext context, double size) {
  return MediaQuery.of(context).size.width * size;
}

screenh(BuildContext context, double size) {
  return MediaQuery.of(context).size.height * size;
}
