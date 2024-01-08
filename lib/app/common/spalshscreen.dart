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

  bool isTop = true;

  goup() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var navigator = Navigator.of(context);
      setState(() => isTop = !isTop);
      await Future.delayed(const Duration(seconds: 3));
      SharedPreferences.getInstance().then((value) {
        bool isLogin = value.getBool(IsLogin) ?? false;
        if (isLogin) {
          navigator.push(MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ));
        } else {
          navigator.push(MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ));
        }
      });
    });
  }

  // dynamic size;
  // double height = 0.00;
  // double width = 0.00;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.appcolor,
      body: Container(
        width: size.width,
        height: size.height,
        child: AnimatedAlign(
          duration: const Duration(seconds: 1),
          alignment: isTop ? Alignment.topCenter : Alignment.center,
          child: Image.asset(
            AssetImages.logo,
            height: size.height / 6,
            // fit: BoxFit.fitHeight,
          ),
        ),
      ),
      // body: Center(
      //     child: Image.asset(AssetImages.splashh,height: height/6,fit: BoxFit.fitHeight,)),
    );
  }
}
