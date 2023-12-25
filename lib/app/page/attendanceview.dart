import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../global/color.dart';
import '../../global/prefsname.dart';
import '../../helper/api_helper.dart';
import '../../helper/url_holder.dart';
import '../../model/attendance_obj.dart';
import '../../model/select_model.dart';
import '../../model/user_details.dart';
import '../widget/custom_animation.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _ViewState();
}

class _ViewState extends State<AttendanceView> {
  String fromDateShow = "--";
  String fromDate = "";
  String toDate = "";
  String toDateShow = "--";
  DateTime fromDate_ = DateTime.now();
  DateTime toDate_ = DateTime.now();

//Calculate
  int workingDays = 30;

//Calculate
  @override
  void initState() {
    super.initState();
    loadUserDetails();
    setInitDate();
  }

  static DateTime getLastDateOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime getFirstDateOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  void setInitDate() {
    fromDate_ = getFirstDateOfMonth(fromDate_);
    fromDate = DateFormat('yyyy-MM-dd').format(getFirstDateOfMonth(fromDate_));
    fromDateShow =
        DateFormat('dd MMM yyyy').format(getFirstDateOfMonth(fromDate_));
    toDate = DateFormat('yyyy-MM-dd').format(getLastDateOfMonth(toDate_));
    toDateShow = DateFormat('dd MMM yyyy').format(getLastDateOfMonth(toDate_));
    toDate_ = getLastDateOfMonth(toDate_);
    workingDays = (toDate_.day - fromDate_.day) + 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  var _totalDuration = 0.0;
  var _totalLate = 0.0;
  var _present = 0;
  var _absent = 0;
  var _miss = 0;
  var _earlyByHours = 0.0;
  var _otDuration = 0.0;
  var _earlyEntry = 0.0;

  var _joiningMonthIndex = 0;
  var _joiningYearIndex = 0;
  var monthName = "Select";
  var monthNameID = "0";
  var yearName = "Select";
  var yearID = "0";
  late List<SelectModel> joinMonthArray = [];
  late List<SelectModel> joinYearArray = [];

  PreferredSizeWidget globalAppBar(title) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: 1,
      backgroundColor: Colors.white,
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.normal, fontSize: 17, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: globalAppBar("Attendance"),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height,
            color: Colors.white,
            width: (width > 500) ? 500 : width,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "From",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_60,
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: fromDate_,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 366)),
                                      // firstDate: fromDate_,
                                      lastDate: DateTime.now())
                                  .then((value) {
                                if (value != null) {
                                  fromDate_ = value;
                                  fromDate =
                                      DateFormat('dd/MM/yyyy').format(value);
                                  fromDateShow =
                                      DateFormat('dd MMM yyyy').format(value);
                                  toDateShow = "---";
                                  toDate_ = value;
                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.GREY_40,
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 7, bottom: 7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      fromDateShow,
                                      style: const TextStyle(
                                          color: AppColor.GREY_60,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.calendar_today,
                                        size: 15, color: AppColor.PRIMARY_COLOR)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "To",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.GREY_60,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: fromDate_,
                                      firstDate: fromDate_,
                                      lastDate: getLastDateOfMonth(fromDate_))
                                  .then((value) {
                                if (value != null) {
                                  toDate_ = value;
                                  toDate =
                                      DateFormat('dd/MM/yyyy').format(value);
                                  toDateShow =
                                      DateFormat('dd MMM yyyy').format(value);
                                  getAttendance();
                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.GREY_40,
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 7, bottom: 7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      toDateShow,
                                      style: const TextStyle(
                                          color: AppColor.GREY_60,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.calendar_today,
                                        size: 15, color: AppColor.PRIMARY_COLOR)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
                DAnimation(
                    visible: _loading == false && toDateShow != "---",
                    child: InkWell(
                      onTap: () {
                        getAttendance();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(colors: [
                              AppColor.PRIMARY_COLOR,
                              AppColor.PRIMARY_COLOR,
                            ])),
                        child: const Center(
                          child: Text(
                            "VIEW",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                Visibility(
                  visible: _loading == true,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          color: AppColor.PRIMARY_COLOR,
                        ),
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        reverse: false,
                        itemCount: _attendanceModel.length,
                        itemBuilder: (context, index) {
                          EmployeeAttendance ad = _attendanceModel[index];
                          return Card(
                            child: Row(
                              children: [
                                // Container(
                                //   width: 3,
                                //   height: ad.StatusID == ATT_PRESENT ||
                                //       ad.StatusID == ATT_MIS
                                //       ? 100
                                //       : 20,
                                //   color: getStatusColor(ad.StatusID),
                                // ),
                                Expanded(
                                    child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Date",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ad.employeeAttendanceDate ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Status",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    ad.employeeAttendanceOutTime ==
                                                            ""
                                                        ? "MIS"
                                                        : "PRESENT",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            getStatusColor(1),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Day",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                DateFormat('EEEE').format(
                                                    DateFormat('dd-MM-yyyy').parse(
                                                        ad.employeeAttendanceDate ??
                                                            "")),
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "In Time",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          ad.employeeAttendanceInTime ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Out Time",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.grey),
                                                      ),
                                                      Text(
                                                        ad.employeeAttendanceOutTime ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                height: 15,
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        const Text(
                                                          "Shift In",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          ad.officeIntime ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                        "Shift Out",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.grey),
                                                      ),
                                                      Text(
                                                        ad.officeOuttime ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              )),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.grey[200],
                                            height: 1,
                                            margin: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [

                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [

                                                      Text(
                                                        ad.intimeEarlyLate ??
                                                            "0",
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                height: 15,
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [

                                                        Text(
                                                          ad.outtimeEarlyLate ??
                                                              "0",
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              )),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        }))
              ],
            ),
          )
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 110,
      //   color: Colors.grey[50],
      //   child: Column(
      //     children: [
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   workingDays.toString(),
      //                   style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.blue),
      //                 ),
      //                 const Text(
      //                   "Working Days",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   _present.toString(),
      //                   style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.green),
      //                 ),
      //                 const Text(
      //                   "Present Days",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   _absent.toString(),
      //                   style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.red),
      //                 ),
      //                 const Text(
      //                   "Absent Days",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   _miss.toString(),
      //                   style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.blue),
      //                 ),
      //                 const Text(
      //                   "Missed Days",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           ))
      //         ],
      //       ),
      //       Container(
      //         height: 1,
      //         color: Colors.grey[300],
      //         margin: const EdgeInsets.only(top: 6, bottom: 6),
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   _totalDuration > 60
      //                       ? (_totalDuration / 60).toStringAsFixed(2) +
      //                           " hr(s)"
      //                       : _totalDuration.toString() + " min(s)",
      //                   style: const TextStyle(
      //                       fontSize: 12,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.grey),
      //                 ),
      //                 const Text(
      //                   "Total Hours",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   _totalLate > 60
      //                       ? (_totalLate / 60).toStringAsFixed(2) + " hr(s)"
      //                       : _totalLate.toString() + " min(s)",
      //                   style: const TextStyle(
      //                       fontSize: 12,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.grey),
      //                 ),
      //                 const Text(
      //                   "Late By",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 Text(
      //                   _earlyByHours > 60
      //                       ? (_earlyByHours / 60).toStringAsFixed(2) + " hr(s)"
      //                       : _earlyByHours.toString() + " min(s)",
      //                   style: const TextStyle(
      //                       fontSize: 12,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.red),
      //                 ),
      //                 const Text(
      //                   "Early Going By",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           )),
      //           Expanded(
      //               child: Center(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 Text(
      //                   _otDuration > 60
      //                       ? (_otDuration / 60).toStringAsFixed(2) + " hr(s)"
      //                       : _otDuration.toString() + " min(s)",
      //                   style: const TextStyle(
      //                       fontSize: 12,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.blue),
      //                 ),
      //                 const Text(
      //                   "OT",
      //                   style: TextStyle(fontSize: 10),
      //                 )
      //               ],
      //             ),
      //           ))
      //         ],
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  UserDetails user = new UserDetails();

  void loadUserDetails() async {
    SharedPreferences.getInstance().then((value) {
      var _data = value.getString(Userdetails);
      var j_data = jsonDecode(_data!);
      print("-----> $j_data");
      user = UserDetails.fromJson(j_data[0]);

      try {
        joinMonthArray.add(SelectModel(1, "January".toUpperCase()));
        joinMonthArray.add(SelectModel(2, "February".toUpperCase()));
        joinMonthArray.add(SelectModel(3, "March".toUpperCase()));
        joinMonthArray.add(SelectModel(4, "April".toUpperCase()));
        joinMonthArray.add(SelectModel(5, "May".toUpperCase()));
        joinMonthArray.add(SelectModel(6, "June".toUpperCase()));
        joinMonthArray.add(SelectModel(7, "July".toUpperCase()));
        joinMonthArray.add(SelectModel(8, "August".toUpperCase()));
        joinMonthArray.add(SelectModel(9, "September".toUpperCase()));
        joinMonthArray.add(SelectModel(10, "October".toUpperCase()));
        joinMonthArray.add(SelectModel(11, "November".toUpperCase()));
        joinMonthArray.add(SelectModel(12, "December".toUpperCase()));
        var date = DateTime.now();
        var _year = date.year;
        var year = date.year;
        var month = date.month;
        _joiningYearIndex = _year;
        _joiningMonthIndex = month - 1;
        monthName = joinMonthArray[_joiningMonthIndex].Name;
        monthNameID = joinMonthArray[_joiningMonthIndex].ID.toString();
        yearName = _year.toString();

        joinYearArray.add(SelectModel(year, year.toString()));
        for (var a = 0; a < 4; a++) {
          _year = _year - 1;
          joinYearArray.add(SelectModel(_year, _year.toString()));
        }
        getAttendance();
      } catch (ee) {
        print(ee.toString());
      }
      setState(() {});
    });
  }

  List<EmployeeAttendance> _attendanceModel = [];

  String formatDuration(int Minute) {
    Duration duration = Duration(seconds: Minute);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    String formattedHours = hours.abs().toString().padLeft(2, '0');
    String formattedMinutes = minutes.abs().toString().padLeft(2, '0');

    String formattedDuration = '${formattedHours}:${formattedMinutes}';
    if (duration.isNegative) {
      formattedDuration = '-$formattedDuration';
    }
    return Minute.toString();
    //return formattedDuration;
  }

  void getAttendance() {
    setState(() {
      _loading = true;
    });
    DateTime today = DateTime.now();
    _attendanceModel.clear();
    Map<String, String> variables = {
      'employee_id': user.employeeId ?? "0",
      'from_date': fromDate,
      'to_date': toDate,
    };
    postAPI(postObject(variables), API_URL + "fetch_attendance").then((data) {
      _loading = false;
      var _data = data.body;
      var j_data = jsonDecode(_data);
      print("-----> $j_data");
      if (j_data != null && j_data is List) {
        for (var attendanceData in j_data) {
          EmployeeAttendance attendance =
              EmployeeAttendance.fromJson(attendanceData);
          _attendanceModel.add(attendance);
        }
      }
      setState(() {});
    });
  }

  bool _loading = true;

  MaterialColor getStatusColor(id) {
    if (id == ATT_HOLIDAY) {
      return Colors.yellow;
    }
    if (id == ATT_LEAVE) {
      return Colors.red;
    }
    if (id == ATT_WEEK_OFF) {
      return Colors.brown;
    }
    if (id == ATT_ABSENT) {
      return Colors.red;
    }
    if (id == ATT_PRESENT) {
      return Colors.green;
    }
    if (id == ATT_MIS) {
      return Colors.pink;
    } else {
      return Colors.pink;
    }
  }

  int ATT_HOLIDAY = 1;
  int ATT_LEAVE = 2;
  int ATT_WEEK_OFF = 3;
  int ATT_ABSENT = 4;
  int ATT_PRESENT = 5;
  int ATT_MIS = 6;
}
