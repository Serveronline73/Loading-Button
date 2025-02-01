// TODO für verschiedene display größen anpassen

import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double screenWidht(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double responsiveSize(BuildContext context, double size) {
    return size * (screenWidht(context) / 375) * size;
  }
}
