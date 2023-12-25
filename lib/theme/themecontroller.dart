import 'package:bsthrm/theme/theme.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/prefsname.dart';


class Themecontroler extends GetxController{
  @override
  void onInit()
  {
    SharedPreferences.getInstance().then((value) {
      isdark = value.getBool(DarkMode)??false;
    });
    update();
    super.onInit();
  }

  var isdark = false;
  Future<void> changeThem (state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isdark = prefs.getBool(DarkMode) ?? true;
    isdark = !isdark;

    if (state == true) {
      Get.changeTheme(Mythemes.darkTheme);
      isdark = true;
    }
    else {
      Get.changeTheme(Mythemes.lightTheme);
      isdark = false;
    }
    update();
  }

}