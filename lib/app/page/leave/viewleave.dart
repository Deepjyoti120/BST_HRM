import 'dart:typed_data';

import 'package:bsthrm/app/page/leave/viewleave.dart';
import 'package:bsthrm/global/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../global/color.dart';
import '../../../global/icons.dart';
import '../../../global/prefsname.dart';
import '../../../model/user_details.dart';
import '../../widget/custom_animation.dart';
import 'package:image/image.dart' as Img;

class ViewLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveFormState createState() => _ApplyLeaveFormState();
}

class _ApplyLeaveFormState extends State<ViewLeaveScreen> {
  @override
  void initState() {
    getUser();

    super.initState();
  }

  final TextEditingController reasonController = TextEditingController();

  // Add more controllers for other fields if needed
  getUser() {
    SharedPreferences.getInstance().then((value) {
      var _data = value.getString(Userdetails);
      var j_data = jsonDecode(_data!);
      print("-----> $j_data");
      user = UserDetails.fromJson(j_data[0]);
      setInitDate();
      setState(() {});
    });
  }

  String fromDateShow = "";
  String fromDate = "";
  String toDate = "";
  String toDateShow = "";
  DateTime fromDate_ = DateTime.now();
  DateTime toDate_ = DateTime.now();
  bool _loading = false;


  List<dynamic> leaveList = []; // List to hold leave details
  void setInitDate() {
    fromDate = DateFormat('yyyy-MM-dd').format(fromDate_);
    fromDateShow = "";
    toDate = DateFormat('yyyy-MM-dd').format(toDate_);
    toDateShow = "";
    fetchLeaveDetails(0);
  }

  Future<void> fetchLeaveDetails(default_) async {
    setState(() {
      _loading = true;
    });
    String fromdate = "";
    String todate = "";
    print(fromDateShow+"/"+toDateShow);
    if (fromDateShow!="" && toDateShow!="") {
      fromdate = DateFormat('yyyy-MM-dd').format(fromDate_);
      todate = DateFormat('yyyy-MM-dd').format(toDate_);
    }

    final url = Uri.parse('https://ragroup.ind.in/api/fetch_my_leave_list');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'security_authentication_id': 'd347774d04690c2c5e7457a8a03e02e7',
      'security_token': '2b45da5375d29a009023e25f27a2ddd4',
      'employee_id': user.employeeId ?? "0",
      'from_date': fromdate,
      'to_date': todate,
      // Add more fields as needed
    });

    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      setState(() {
        _loading = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          leaveList = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to fetch leave details');
      }
    } catch (e) {
      print('Exception while fetching leave details: $e');
      // Handle exceptions or errors here
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String add_file_text = "Add File";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: globalAppBar("Leave"),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height,
            color: Colors.white,
            width: (width > 500) ? 500 : width,
            child: Column(children: [
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
                                    lastDate:
                                        DateTime.now().add(Duration(days: 366)))
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
                                lastDate:fromDate_.add(Duration(days: 365)))
                                .then((value) {
                              if (value != null) {
                                toDate_ = value;
                                toDate = DateFormat('dd/MM/yyyy').format(value);
                                toDateShow =
                                    DateFormat('dd MMM yyyy').format(value);
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
                      fetchLeaveDetails(1);
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
              SizedBox(height: 20,),
              Expanded(
                  child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                reverse: false,
                itemCount: leaveList.length,
                itemBuilder: (BuildContext context, int index) {
                  final leave = leaveList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 4,
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.employeeName ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '${leave["apply_time"]}',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.blue),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Card(
                                color: leave["status"].toString().toLowerCase()=="rejected"?Colors.red:Colors.green,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 3, bottom: 3),
                                    child: Text(
                                      '${leave["status"].toString().toUpperCase()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: leave["status"].toString().toLowerCase()=="rejected"?Colors.red[100]:Colors.green[100]),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[400],
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${leave["no_of_days"]} DAY(S)",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.PRIMARY_GREEN,
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              Row(
                                children: [

                                  const Text(
                                    "Leave From :",
                                    style: TextStyle(
                                        fontSize: 12, color: AppColor.BLACK21),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${leave["leave_from"]}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.BLACK21),
                                  ),
                                  const Text(
                                    " to ",
                                    style: TextStyle(
                                        fontSize: 12, color: AppColor.BLACK21),
                                  ),
                                  Text(
                                    '${leave["leave_to"]}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.BLACK21),
                                  ),
                                ],
                              ),

                              Text(
                                '${leave["leave_reason"]}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      Visibility(child:  Column(
                        children: [
                          Divider(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [

                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                         '${leave["approve_rejection_by_name"]}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          leave["status"].toString().toLowerCase()=="rejected"? 'Rejected By':'Approved By',
                                          style: const TextStyle(
                                              fontSize: 9, color: Colors.grey,fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(

                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${leave["approve_rejection_time"]}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          leave["status"].toString().toLowerCase()=="rejected"? 'Rejection Time':'Approval Time',
                                          style: const TextStyle(
                                              fontSize: 9, color: Colors.grey,fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),visible:  leave["status"].toString().toLowerCase()!="pending",)

                      ],
                    ),
                  );
                },
              ))
            ]),
          )
        ],
      ),
    );
  }

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

  UserDetails user = new UserDetails();
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
        final Img.Image resizedImage = Img.copyResize(originalImage, width: originalImage.width ~/ 2);

        // Create an encoder with specific quality settings (adjust quality as needed)
        final Img.PngEncoder encoder = Img.PngEncoder(level: 1); // Adjust the compression level here (1 is just an example)

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
      }
    }
  }
}
