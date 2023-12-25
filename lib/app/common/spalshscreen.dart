import 'package:bsthrm/app/common/loginpage.dart';
import 'package:bsthrm/app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/color.dart';
import '../../global/icons.dart';
import '../../global/prefsname.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goup();
  }

  goup() async {
    var navigator = Navigator.of(context);
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences.getInstance().then((value) {
      bool isLogin = value.getBool(IsLogin)??false;
      if(isLogin){
        navigator.push(MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          },
        ));
      }
      else{
        navigator.push(MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ));
      }
    });

  }

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: AppColor.appcolor,
      body: Center(
          child: Image.asset(AssetImages.splashh,height: height/6,fit: BoxFit.fitHeight,)),
    );
  }
}
