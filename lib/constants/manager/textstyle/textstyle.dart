import 'package:assignment/constants/manager/color/color.dart';
import 'package:flutter/material.dart';

AppTextStyle appTextStyle = AppTextStyle();

class AppTextStyle {
  TextStyle f20w700buttontxtcolor = TextStyle(
    color: appColor.buttontxtcolor,
    fontSize: 20,
  );
  TextStyle f18w400black = TextStyle(
    color: appColor.textcolor,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  TextStyle f18w500black = TextStyle(
    color: appColor.textcolor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  TextStyle f18w400grey = TextStyle(
    color: appColor.textgreycolor,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  TextStyle f20w400black = TextStyle(
    color: appColor.textcolor,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  TextStyle f20w500black = TextStyle(
    color: appColor.textcolor,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  TextStyle f25w500black = TextStyle(
    color: appColor.textcolor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  TextStyle f16w200black = TextStyle(
    color: appColor.textcolor,
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );
  TextStyle f16w400grey = TextStyle(
    color: appColor.textgreycolor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  TextStyle f16w400greydec = TextStyle(
    color: appColor.textgreycolor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline, // Underline text
    decorationColor: appColor.textgreycolor, // Underline color
  );
  TextStyle f14w400grey = TextStyle(
    color: appColor.textgreycolor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle f14w400black = TextStyle(
    color: appColor.textcolor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle f14w500black = TextStyle(
    color: appColor.textcolor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  TextStyle f16w400black = TextStyle(
    color: appColor.textcolor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  TextStyle f14w400orange = TextStyle(
    color: appColor.buttoncolor, // Text color
    fontSize: 14, // Font size
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline, // Underline text
    decorationColor: appColor.buttoncolor, // Underline color
  );
  TextStyle labeltxt = TextStyle(
    fontSize: 12,
    color: appColor.textgreycolor,
  );
  TextStyle f22w400black = TextStyle(
    color: appColor.textcolor, // Text color
    fontSize: 22, // Font size
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline, // Underline text
    decorationColor: Colors.black, // Underline color
  );
  TextStyle f16w500orange = TextStyle(
    color: appColor.buttoncolor, // Text color
    fontSize: 16, // Font size
    fontWeight: FontWeight.w500,
  );

  // TextStyle f30w400white = TextStyle(
  //   color: appColor.primarytxtcolor,
  //   fontSize: 30,
  //   fontFamily: 'popins_semibold',
  //   letterSpacing: 2,
  // );
  //  TextStyle f40w400white = TextStyle(
  //   color: appColor.primarytxtcolor,
  //   fontSize: 40,
  //   fontFamily: 'popins_semibold',
  //   letterSpacing: 2,
  // );
  // TextStyle f40w800white = TextStyle(
  //     color: appColor.primarytxtcolor,
  //     fontSize: 40,
  //     fontFamily: 'popins_bold',
  //     letterSpacing: 2,
  //     fontWeight: FontWeight.w800);
  // TextStyle f40w800yellow = TextStyle(
  //   color: appColor.secondarytxtcolor,
  //   fontFamily: 'popins_medium',
  //   fontSize: 40,
  // );
}
