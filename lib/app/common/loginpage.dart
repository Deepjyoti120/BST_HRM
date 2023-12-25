import 'dart:convert';

import 'package:bsthrm/global/icons.dart';
import 'package:bsthrm/helper/api_helper.dart';
import 'package:bsthrm/model/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/color.dart';
import '../../global/fontstyle.dart';
import 'package:flutter_svg/svg.dart';

import '../../global/prefsname.dart';
import '../../global/widgets.dart';
import '../../helper/url_holder.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _WelcomePageState();
}

bool isLoading = false
;

class _WelcomePageState extends State<LoginPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  bool _obscureText = true;

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      Stack(
        children: [
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 12,
                ),
                Text(
                  "Login".tr,
                  style:
                  hsSemiBold.copyWith(fontSize: 36, color: AppColor.appcolor),
                ),
                SizedBox(
                  height: height / 16,
                ),
                TextField(
                  controller: _loginID,
                  style: hsMedium.copyWith(fontSize: 16, color: AppColor.textgray),
                  decoration: InputDecoration(
                      hintStyle:
                      hsMedium.copyWith(fontSize: 16, color: AppColor.textgray),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(Svgimage.icemail,
                            height: height / 36,
                            colorFilter: const ColorFilter.mode(
                                AppColor.textgray, BlendMode.srcIn)),
                      ),
                      hintText: "Login ID",
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.greyy))),
                ),
                SizedBox(
                  height: height / 36,
                ),
                TextField(
                  controller: _password,
                  obscureText: _obscureText,
                  style: hsMedium.copyWith(fontSize: 16, color: AppColor.textgray),
                  decoration: InputDecoration(
                      hintStyle:
                      hsMedium.copyWith(fontSize: 16, color: AppColor.textgray),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(Svgimage.iclock,
                            height: height / 36,
                            colorFilter: const ColorFilter.mode(
                                AppColor.textgray, BlendMode.srcIn)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: _togglePasswordStatus,
                        color: AppColor.textgray,
                      ),
                      hintText: "Password",
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.greyy))),
                ),
                SizedBox(
                  height: height / 56,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //         splashColor: AppColor.transparent,
                //         highlightColor: AppColor.transparent,
                //         onTap: () {
                //           // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //           //   return const DailozForgotpassword();
                //           // },));
                //         },
                //         child: Text("Forgot_Password".tr,style: hsRegular.copyWith(fontSize: 12,color: AppColor.appcolor),)),
                //   ],
                // ),
                SizedBox(
                  height: height / 20,
                ),
                InkWell(
                  splashColor: AppColor.transparent,
                  highlightColor: AppColor.transparent,
                  onTap: () {
                    checkLogin();
                  },
                  child: Container(
                    width: width / 1,
                    height: height / 15,
                    decoration: BoxDecoration(
                        color: AppColor.appcolor,
                        borderRadius: BorderRadius.circular(14)),
                    child: Center(
                        child: Text(
                          "Login".tr,
                          style:
                          hsSemiBold.copyWith(fontSize: 16, color: AppColor.white),
                        )),
                  ),
                ),

                SizedBox(
                  height: height / 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //         height: height / 500,
                //         width: width / 3.5,
                //         color: AppColor.bggray),
                //     SizedBox(width: width / 56),
                //     Text(
                //       "or_with".tr,
                //       style: hsRegular.copyWith(
                //           fontSize: 12, color: AppColor.textgray),
                //     ),
                //     SizedBox(width: width / 56),
                //     Container(
                //         height: height / 500,
                //         width: width / 3.5,
                //         color: AppColor.bggray),
                //   ],
                // ),
                // SizedBox(height: height/26,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //       },
                //       child: Container(
                //         width: width/6.5,
                //         height: height/14,
                //         decoration: BoxDecoration(
                //             border: Border.all(color: AppColor.bggray,),
                //             borderRadius: BorderRadius.circular(50)
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(10),
                //           child: Image.asset(AssetImages.google,height: height/36,),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: width/20,),
                //     InkWell(
                //       onTap: () {
                //       },
                //       child: Container(
                //         width: width/6.5,
                //         height: height/14,
                //         decoration: BoxDecoration(
                //             border: Border.all(color: AppColor.bggray,),
                //             borderRadius: BorderRadius.circular(50)
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(10),
                //           child: Image.asset(AssetImages.facebook,height: height/36,),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // const Spacer(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Dont_have_an_account".tr,
                //       style: hsRegular.copyWith(
                //           fontSize: 14, color: AppColor.textgray),
                //     ),
                //     Text(
                //       "SignUp".tr,
                //       style: hsSemiBold.copyWith(
                //         fontSize: 14,),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.6), // Adjust the opacity and color as needed
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white, // Adjust the color of the loader
                  )
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  TextEditingController _loginID = TextEditingController();
  TextEditingController _password = TextEditingController();

  void checkLogin() {
    Map<String, String> variables = {
      'login_id': _loginID.text.trim().toString(),
      'password': _password.text.trim().toString(),
    };
    if (_loginID.text == "") {
      showMessage("Please Enter Login ID", true, context);
    } else if (_password.text == "") {
      showMessage("Please Enter Password", true, context);
    } else {
      setState(() {
        isLoading=true;
      });
      postAPI(postObject(variables), API_URL + "login").then((data) {
        var _data = data.body;
        var j_data = jsonDecode(_data);
        print("-----> $j_data");
        UserDetails user = UserDetails.fromJson(j_data[0]);
        print("-----> ${user.message}");
        setState(() {
          isLoading=false;
        });
        if(user.message=="0"){
          showMessage("Invalid Login ID/Password ", true, context);
        }
        else{
          SharedPreferences.getInstance().then((value) {
            value.setBool(IsLogin, true);
            value.setString(Userdetails, _data);
            var navigator = Navigator.of(context);
            navigator.push(MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ));
          });
        }
        try {} catch (ex) {
          setState(() {
            isLoading=false;
          });
          showMessage("Error in connecting server", false, context);
        }
      });
    }
  }
}
