import 'dart:async';
import 'dart:convert';
import 'package:bsthrm/app/drawer.dart';
import 'package:bsthrm/app/log/claim_insert.dart';
import 'package:bsthrm/app/log/claim_view.dart';
import 'package:bsthrm/app/page/attendanceview.dart';
import 'package:bsthrm/app/page/leave/applyleav.dart';
import 'package:bsthrm/app/page/leave/viewleave.dart';
import 'package:bsthrm/global/prefsname.dart';
import 'package:bsthrm/helper/api_helper.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../global/color.dart';
import '../global/fontstyle.dart';
import '../global/icons.dart';
import '../global/widgets.dart';
import '../helper/url_holder.dart';
import '../model/attendance_obj.dart';
import '../model/user_details.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDetails user = UserDetails();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _currentAddress = "";
  String? base64Image = "";

  Future<void> _takePictureAndConvertToBase64() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final Img.Image? originalImage = Img.decodeImage(bytes);

      if (originalImage != null) {
        // Resize image to 50% of its original quality
        final Img.Image resizedImage =
            Img.copyResize(originalImage, width: originalImage.width ~/ 2);

        // Create an encoder with specific quality settings (adjust quality as needed)
        final Img.PngEncoder encoder = Img.PngEncoder(
            level:
                1); // Adjust the compression level here (1 is just an example)

        // Encode resized image to PNG format with reduced quality
        final List<int> resizedBytes = encoder.encode(resizedImage);

        // Convert resized image bytes to Uint8List
        final Uint8List resizedUint8List = Uint8List.fromList(resizedBytes);

        setState(() {
          _imageBytes = resizedUint8List;
        });

        // Use resizedUint8List as needed (e.g., send it to an API)
        base64Image = base64Encode(resizedBytes);
        print('Base64 Image: $base64Image');
        _showImagePopup();
      }
    }
  }

  String timer = "00:00";
  double latitude = 0;
  double longitude = 0;

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      latitude = position.latitude;
      longitude = position.longitude;

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
      _takePictureAndConvertToBase64();
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _showImagePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _imageBytes != null
                  ? Image.memory(_imageBytes!)
                  : const Text('No image available'),
              const SizedBox(height: 20),
              _currentAddress != null
                  ? Text('Address: $_currentAddress')
                  : const Text('Fetching address...'),
              const SizedBox(height: 20),
              InkWell(
                splashColor: AppColor.transparent,
                highlightColor: AppColor.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                  if (checkIN) {
                    saveAttendance();
                  } else {
                    if (!attn_finished && attn_id != 0) {
                      updateAttendance();
                    }
                  }
                },
                child: Container(
                  width: width / 1,
                  height: height / 15,
                  decoration: BoxDecoration(
                      color: AppColor.appcolor,
                      borderRadius: BorderRadius.circular(14)),
                  child: Center(
                    child: Text(
                      checkIN ? "Check In" : "Check Out",
                      style: hsSemiBold.copyWith(
                          fontSize: 16, color: AppColor.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getUser() {
    SharedPreferences.getInstance().then((value) {
      var _data = value.getString(Userdetails);
      var j_data = jsonDecode(_data!);
      debugPrint("-----> $j_data");
      user = UserDetails.fromJson(j_data[0]);
      final appState = context.read<AppStateCubit>();
      appState.userDetails = user;
      getAttendance();
      checkAccess(user);
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void checkAccess(UserDetails user) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (user.employeeStatus == "2") {
        _scaffoldKey.currentState!.openDrawer();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final appState = context.watch<AppStateCubit>();
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(), //home menu
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              "hi, ${(user.employeeName?.length ?? 0) > 20 ? '${user.employeeName?.substring(0, 20)}..' : user.employeeName}-${user.empid ?? ""}",
              style: hsSemiBold.copyWith(fontSize: 20),
            ),
          ),
          body: appState.userDetails?.employeeStatus == "4"
              ? SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: width / 36, right: width / 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    if (!attn_finished) {
                                      checkAttendance();
                                    }
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                        color: AppColor.lightblue,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 36,
                                          vertical: height / 66),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.attn1,
                                                height: 60,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              attn_finished
                                                  ? const Text("")
                                                  : Text(
                                                      '${hours == 0 ? '' : '${hours.toString().padLeft(2, '0')}:'}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                                      style: hsMedium.copyWith(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColor
                                                              .redbglight),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Attendance".tr,
                                            style: hsMedium.copyWith(
                                                fontSize: 11,
                                                color: AppColor.black),
                                          ),
                                          Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 2,
                                                  bottom: 2),
                                              child: attn_finished
                                                  ? const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Checked Out"),
                                                        Icon(
                                                          Icons.check,
                                                          size: 15,
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(checkIN
                                                            ? "Check In"
                                                            : "Check Out"),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_rounded,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AttendanceView()),
                                    );
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                        color: AppColor.purple,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 36,
                                          vertical: height / 66),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.attn2,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: AppColor.white,
                                                size: 22,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "View Attendance".tr,
                                            style: hsMedium.copyWith(
                                                fontSize: 16,
                                                color: AppColor.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ClaimLog()),
                                    );
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                        color: AppColor.lightred,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 36,
                                          vertical: height / 66),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.attn4,
                                                height: 65,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              Text("0 KM".tr,
                                                  style: hsMedium.copyWith(
                                                      fontSize: 16,
                                                      color:
                                                          AppColor.redbglight)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Attendance Log".tr,
                                            style: hsMedium.copyWith(
                                                fontSize: 11,
                                                color: AppColor.white),
                                          ),
                                          const Card(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 2,
                                                  bottom: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Claim Now"),
                                                  Icon(
                                                    Icons.my_location,
                                                    size: 15,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ClaimView()),
                                    );
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                        color: AppColor.lightgreen,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 36,
                                          vertical: height / 66),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.attn3,
                                                height: 70,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: AppColor.black,
                                                size: 22,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "View".tr,
                                            style: hsMedium.copyWith(
                                                fontSize: 12,
                                                color: AppColor.black),
                                          ),
                                          Text(
                                            "Claims",
                                            style: hsRegular.copyWith(
                                                fontSize: 14,
                                                color: AppColor.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ApplyLeaveForm(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                      color: AppColor
                                          .lightpurple, // Change color as needed
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width / 36,
                                        vertical: height / 66,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.applyLeaveIcon,
                                                height: 90,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: AppColor.black,
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            "Apply Leave", // Change text as needed
                                            style: hsMedium.copyWith(
                                              fontSize: 12,
                                              color: AppColor.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: AppColor.transparent,
                                  highlightColor: AppColor.transparent,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewLeaveScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: height / 5,
                                    width: width / 2.2,
                                    decoration: BoxDecoration(
                                      color: AppColor
                                          .orange, // Change color as needed
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width / 36,
                                        vertical: height / 66,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                BstImages.leaveViewIcon,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: AppColor.white,
                                                size: 22,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "View Leave", // Change text as needed
                                            style: hsMedium.copyWith(
                                              fontSize: 16,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Today's Logs".tr,
                            //       style: hsSemiBold.copyWith(fontSize: 24),
                            //     ),
                            //     const Spacer(),
                            //     Text(
                            //       "25 KM".tr,
                            //       style: hsRegular.copyWith(
                            //           fontSize: 12, color: AppColor.appcolor),
                            //     ),
                            //   ],
                            // ),
                            // ListView.builder(
                            //   itemCount: 3,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemBuilder: (context, index) {
                            //     return InkWell(
                            //       splashColor: AppColor.transparent,
                            //       highlightColor: AppColor.transparent,
                            //       onTap: () {
                            //         /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //   return const DailozTaskdetail();
                            // },));*/
                            //       },
                            //       child: Container(
                            //         margin: EdgeInsets.only(bottom: height / 46),
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(14),
                            //             color: AppColor.bggray),
                            //         child: Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: width / 36,
                            //               vertical: height / 66),
                            //           child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 "280, Zoo Road, Guwahati, Assam, 781021",
                            //                 style: hsMedium.copyWith(
                            //                     fontSize: 16, color: AppColor.black),
                            //               ),
                            //               SizedBox(
                            //                 height: height / 200,
                            //               ),
                            //               Text(
                            //                 "10:00 AM",
                            //                 style: hsRegular.copyWith(
                            //                     fontSize: 14,
                            //                     color: AppColor.textgray),
                            //               ),
                            //               SizedBox(
                            //                 height: height / 66,
                            //               ),
                            //               Row(
                            //                 children: [
                            //                   Container(
                            //                       decoration: BoxDecoration(
                            //                           color: const Color(0x338F99EB),
                            //                           borderRadius:
                            //                               BorderRadius.circular(5)),
                            //                       child: Padding(
                            //                         padding: EdgeInsets.symmetric(
                            //                             horizontal: width / 36,
                            //                             vertical: height / 120),
                            //                         child: Text(
                            //                           "View Image",
                            //                           style: hsMedium.copyWith(
                            //                               fontSize: 10,
                            //                               color: AppColor.appcolor),
                            //                         ),
                            //                       )),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text("Please Submit Documents"),
                ),
          // bottomNavigationBar: InkWell(
          //   onTap: () async {
          //     var navigator = Navigator.of(context);
          //     SharedPreferences preferences =
          //         await SharedPreferences.getInstance();
          //     await preferences.clear();
          //     print('All SharedPreferences values removed');
          //     navigator.push(MaterialPageRoute(
          //       builder: (context) {
          //         return const LoginPage();
          //       },
          //     ));
          //   },
          //   child: Container(
          //     height: 25,
          //     margin: const EdgeInsets.all(10),
          //     child: const Center(
          //       child: Text("Log Out"),
          //     ),
          //   ),
          // ),
        ),
        Container(
          // margin: const EdgeInsets.only(top: 90),
          child: Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              // Adjust the opacity and color as needed
              child: const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white, // Adjust the color of the loader
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  bool isLoading = true;

  int getDifferenceInMinutes(String targetDateTimeStr) {
    DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
    DateTime targetDateTime = formatter.parse(targetDateTimeStr);
    DateTime currentDateTime = DateTime.now();

    Duration difference = targetDateTime.difference(currentDateTime);
    int differenceInMinutes = difference.inMinutes;

    return differenceInMinutes
        .abs(); // Absolute value to get the positive difference
  }

  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  late Timer _timer;

  void startCountdownTimer(int differenceInMinutes) {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
        if (seconds == 60) {
          seconds = 0;
          minutes++;
          if (minutes == 60) {
            minutes = 0;
            hours++;
          }
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }

  int attn_id = 0;
  bool attn_finished = false;

  void getAttendance() {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    Map<String, String> variables = {
      'employee_id': user.employeeId ?? "0",
      'from_date': formattedDate,
      'to_date': formattedDate,
    };
    postAPI(postObject(variables), "${API_URL}fetch_attendance").then((data) {
      isLoading = false;
      var _data = data.body;
      var j_data = jsonDecode(_data);
      print("-----> $j_data");
      if (j_data.length > 0) {
        EmployeeAttendance attn = EmployeeAttendance.fromJson(j_data[0]);
        print("-----> ${attn.employeeAttendanceDate}");
        print("-----> ${attn.employeeAttendanceInTime}");
        print("-----> ${attn.employeeAttendanceOutTime}");
        if (attn.employeeAttendanceOutTime == "") {
          checkIN = false;
          attn_id = int.parse(attn.employeeAttendanceId ?? "0");
          var targetDateTimeStr =
              "${attn.employeeAttendanceDate!} ${attn.employeeAttendanceInTime!}";
          minutes = getDifferenceInMinutes(targetDateTimeStr);
          startCountdownTimer(minutes);
        } else {
          attn_finished = true;
        }
      } else {
        checkIN = true;
      }
      setState(() {});
    });
  }

  bool checkIN = true;

  void checkAttendance() {
    _fetchCurrentLocation();
  }

  void saveAttendance() {
    setState(() {
      isLoading = true;
    });
    Map<String, String> variables = {
      'employee_id': user.employeeId ?? "",
      'employee_intime_longitude': longitude.toString(),
      'employee_intime_latitude': latitude.toString(),
      'employee_attendance_intime_photo': base64Image.toString(),
      'address': _currentAddress.toString(),
    };
    postAPI(postObject(variables), "${API_URL}insertattendance").then((data) {
      try {
        var _data = data.body;
        print(_data);
        var j_data = jsonDecode(_data);
        print("-----> $j_data");
        UserDetails user = UserDetails.fromJson(j_data[0]);
        print("-----> ${user.message}");

        if (user.message == "0") {
          setState(() {
            isLoading = false;
          });
          showMessage(user.errorCode, true, context);
        } else {
          getAttendance();
        }
      } catch (ex) {
        setState(() {
          isLoading = false;
        });
        showMessage("Error in connecting server", true, context);
      }
    });
  }

  void updateAttendance() {
    setState(() {
      isLoading = true;
    });
    Map<String, String> variables = {
      'employee_attendance_id': attn_id.toString(),
      'employee_id': user.employeeId ?? "",
      'employee_outtime_longitude': longitude.toString(),
      'employee_outtime_latitude': latitude.toString(),
      'employee_attendance_outtime_photo': base64Image.toString(),
      'address': _currentAddress.toString(),
    };
    postAPI(postObject(variables), "${API_URL}updateattendance").then((data) {
      try {
        var _data = data.body;
        print(_data);
        var j_data = jsonDecode(_data);
        print("-----> $j_data");
        UserDetails user = UserDetails.fromJson(j_data[0]);
        print("-----> ${user.message}");

        if (user.message == "0") {
          setState(() {
            isLoading = false;
          });
          showMessage(user.errorCode, true, context);
        } else {
          getAttendance();
        }
      } catch (ex) {
        setState(() {
          isLoading = false;
        });
        showMessage("Error in connecting server", true, context);
      }
    });
  }
}
