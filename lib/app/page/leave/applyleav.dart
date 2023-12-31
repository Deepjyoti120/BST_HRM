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
import '../../../global/prefsname.dart';
import '../../../model/user_details.dart';
import '../../widget/custom_animation.dart';
import 'package:image/image.dart' as Img;

class ApplyLeaveForm extends StatefulWidget {
  @override
  _ApplyLeaveFormState createState() => _ApplyLeaveFormState();
}

class _ApplyLeaveFormState extends State<ApplyLeaveForm> {
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
      setState(() {});
    });
  }

  Future<void> applyLeave() async {
    setState(() {
      _loading=true;
    });
    final url = Uri.parse('https://ragroup.ind.in/api/apply_leave');
    final headers = {
      'Content-Type': 'application/json',
    };
    String fromdate = DateFormat('dd-MM-yyyy').format(fromDate_);
    String todate = DateFormat('dd-MM-yyyy').format(toDate_);
    final body = jsonEncode({
      'security_authentication_id': 'd347774d04690c2c5e7457a8a03e02e7',
      'security_token': '2b45da5375d29a009023e25f27a2ddd4',
      'employee_id': user.employeeId ?? "0",
      'from_date': fromdate,
      'to_date': todate,
      'leave_reason': reasonController.text,
      'employee_leave_file': base64Image,
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
        _loading=false;
      });
      showMessage("Leave Applied", false, context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ViewLeaveScreen(),
        ),
      );
    } catch (e) {
      showMessage("Failed to apply leave", false, context);
      print('Exception while applying leave: $e');
      // Handle exceptions or errors here
    }
  }

  String fromDateShow = "--";
  String fromDate = "";
  String toDate = "";
  String toDateShow = "--";
  DateTime fromDate_ = DateTime.now();
  DateTime toDate_ = DateTime.now();
  bool _loading = false;

  

  void setInitDate() {
    fromDate_ = DateTime.now();
    fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fromDateShow =
        DateFormat('dd MMM yyyy').format(DateTime.now());
    toDate = DateFormat('yyyy-MM-dd').format(toDate_);
    toDateShow = DateFormat('dd MMM yyyy').format(toDate_);
    toDate_ =toDate_;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String add_file_text = "Add Image";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  lastDate: DateTime.now().add(Duration(days: 366)))
                              .then((value) {
                            if (value != null) {
                              fromDate_ = value;
                              fromDate = DateFormat('dd/MM/yyyy').format(value);
                              fromDateShow =
                                  DateFormat('dd MMM yyyy').format(value);
                              toDateShow = "--";
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  lastDate: fromDate_.add(Duration(days: 365)))
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Leave Reason',
                  border: OutlineInputBorder(), // Adding a border
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Adjust padding
                  alignLabelWithHint: true, // Align the label with the hint
                ),
                maxLines: 3, // This allows the field to be multiline
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(child: Text(add_file_text),margin: EdgeInsets.only(left: 15),),
            InkWell(
              onTap: () {
                _takePictureAndConvertToBase64();
              },
              child:    Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color:base64Image == ""
                          ? AppColor.BORDER_COLOR
                          : Colors.green,
                      width: 1.0,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10,
                      top: 12,
                      bottom: 12,
                      right: 10),
                  child: Column(
                    children: [
                      Visibility(
                        visible: base64Image == "",
                        child: const Icon(Icons.add,
                            color: AppColor.BORDER_COLOR),
                      ),
                      Visibility(
                        visible:  base64Image != "",
                        child: const Icon(
                            Icons.check_circle,
                            color: Colors.green),
                      )
                    ],
                  ),
                ),
              ),),
            SizedBox(
              height: 15,
            ),
            DAnimation(
                visible: _loading == false,
                child: InkWell(
                  onTap: () {
                    if (fromDateShow == "--") {
                      showMessage("Please Select From Date ", true, context);
                    } else if (toDateShow == "--") {
                      showMessage("Please Select To Date ", true, context);
                    } else if (reasonController.text == "") {
                      showMessage("Please write leave reason ", true, context);
                    } else {
                      applyLeave();
                    }
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
                        "APPLY",
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
          ],
        ),
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
