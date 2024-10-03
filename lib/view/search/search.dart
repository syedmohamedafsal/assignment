// SearchScreen implementation
import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/constants/manager/textstyle/textstyle.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: appTextStyle.f20w700buttontxtcolor,
        ),
        backgroundColor: appColor.buttoncolor,
      ),
      body: Center(
        child: Text(
          'Search Screen',
          style: appTextStyle.f20w500black,
        ),
      ),
    );
  }
}
