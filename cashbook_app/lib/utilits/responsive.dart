import 'package:flutter/material.dart';

extension Sizing on num {
  ///Responsive height
  double rh(context) {
    //!Don't change [812]
    const double aspectedScreenHeight = 850;

    Size size = MediaQuery.of(context).size;
    double responsiveHeight = size.height * (this / aspectedScreenHeight);
    return responsiveHeight;
  }

  ///Responsive width
  double rw(context) {
    //!Don't change  [375]
    const double aspectedScreenWidth = 375;

    Size size = MediaQuery.of(context).size;
    double responsiveWidth = size.width * (this / aspectedScreenWidth);
    return responsiveWidth;
  }

  ///Responsive font
  double rf(context) {
    const double aspectedScreenHeight = 850;
    return (this / aspectedScreenHeight) * MediaQuery.of(context).size.height;
  }
}