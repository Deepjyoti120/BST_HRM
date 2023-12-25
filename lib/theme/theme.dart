import 'package:flutter/material.dart';

import '../global/color.dart';
import '../global/fontstyle.dart';

class Mythemes {
  static final lightTheme = ThemeData(

    primaryColor: AppColor.appcolor,
    primarySwatch: Colors.grey,
    textTheme: const TextTheme(),
    fontFamily: 'HindSiliguriRegular',
    scaffoldBackgroundColor: AppColor.white,

    appBarTheme: AppBarTheme(
      iconTheme:  const IconThemeData(color: AppColor.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: hsMedium.copyWith(
        color: AppColor.black,
        fontSize: 16,
      ),
      color: AppColor.transparent,
    ),
  );

  static final darkTheme = ThemeData(

    fontFamily: 'HindSiliguriRegular',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: AppColor.white),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: hsMedium.copyWith(
        color: AppColor.white,
        fontSize: 15,
      ),
      color: AppColor.transparent,
    ),
  );
}