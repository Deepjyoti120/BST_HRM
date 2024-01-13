import 'dart:convert';
import 'dart:math';
import 'package:bsthrm/app/log/claim_view.dart';
import 'package:bsthrm/global/widgets.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../global/color.dart';
import '../../global/prefsname.dart';
import '../../model/claim.dart';
import '../../model/user_details.dart';
import 'package:image/image.dart' as Img;

import '../widget/custom_animation.dart';

import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ClaimLog extends StatefulWidget {
  ClaimLog({super.key});

  @override
  State<ClaimLog> createState() => _ClaimLogState();
}

class _ClaimLogState extends State<ClaimLog> {
  String _selectedVehicle = '';
  String? ping = '';
  @override
  void initState() {
    getUser();
    setInitDate();
    super.initState();
  }

  void _selectVehicle(String vehicle) {
    setState(() {
      base64Image = "";
      _selectedVehicle = vehicle;
      if (_selectedVehicle == "Transport" || _selectedVehicle == "Others") {
        ping = "Send for verification";
      } else {
        //_fetchCurrentLocation();
        // fetchLeaveDetails();
        ping = "Mark Log";
      }
    });
  }

  double lastMeter = 0;
  double last_lat = 0;
  double last_lon = 0;

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert degrees to radians
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    // Convert latitudes to radians
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    // Apply Haversine formula
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));

    // Calculate the distance
    double distance = earthRadius * c;
    return distance; // Distance in kilometers
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<void> fetchLeaveDetails() async {
    setState(() {
      _loading = true;
    });
    String fromdate = "";
    fromdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final url = Uri.parse('https://ragroup.ind.in/api/fetch_my_claim_list');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'security_authentication_id': 'd347774d04690c2c5e7457a8a03e02e7',
      'security_token': '2b45da5375d29a009023e25f27a2ddd4',
      'employee_id': user.employeeId ?? "0",
      'from_date': fromdate,
      'to_date': fromdate,
      'type': _selectedVehicle,
      // Add more fields as needed
    });

    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      print(jsonDecode(response.body));
      setState(() {
        _loading = false;
      });
      if (response.statusCode == 200) {
        List<Claim> claims = (json.decode(response.body) as List)
            .map((e) => Claim.fromJson(e))
            .toList();
        if (claims.length > 0) {
          if (claims[0].markLog.length > 0) {
            lastMeter = double.parse(claims[0].markLog[0].markLogDistance);
            last_lat = double.parse(claims[0].markLog[0].markLogLatitude);
            last_lon = double.parse(claims[0].markLog[0].markLogLongitude);
            meter = calculateDistance(last_lat, last_lon, latitude, longitude);
            saveLog();
            print("my last long: " + meter.toString());
          } else {
            saveLog();
          }
        } else {
          saveLog();
        }
      } else {
        throw Exception('Failed to fetch leave details');
      }
    } catch (e) {
      print('Exception while fetching leave details: $e');
      // Handle exceptions or errors here
    }
  }

  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> sendClaim() async {
    if (_selectedVehicle == "Transport" || _selectedVehicle == "Others") {
      if (amountController.text == "") {
        showMessage("Please Enter Amount", true, context);
      } else if (reasonController.text == "") {
        showMessage("Please Enter Comment", true, context);
      } else if (base64Image == "") {
        showMessage("Please Select Image", true, context);
      } else {
        setState(() {
          _loading = true;
        });
        String url = 'https://ragroup.ind.in/api/apply_claim';
        String fromDate = DateFormat('dd-MM-yyyy').format(fromDate_);
        String securityAuthenticationId = 'd347774d04690c2c5e7457a8a03e02e7';
        String securityToken = '2b45da5375d29a009023e25f27a2ddd4';
        String employeeId = user.employeeId ?? "0";
        String claimDate = fromDate;
        String claimType = _selectedVehicle;
        String claimAmount = amountController.text;
        String ticketFileBase64 = base64Image;
        String comment = reasonController.text;

        // Prepare the request body
        Map<String, dynamic> requestBody = {
          'security_authentication_id': securityAuthenticationId,
          'security_token': securityToken,
          'employee_id': employeeId,
          'claim_date': claimDate,
          'claim_type': claimType,
          'claim_amount': claimAmount,
          'ticket_file': ticketFileBase64,
          'comment': comment,
        };

        print(requestBody);
        try {
          var response = await http.post(
            Uri.parse(url),
            body: json.encode(requestBody),
            headers: {
              'Content-Type': 'application/json',
            },
          );
          setState(() {
            _loading = false;
          });
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ClaimView()),
          );
        } catch (e) {
          // Exception occurred during the request
          print('Error: $e');
        }
      }
    } else {
      setState(() {
        _loading = true;
      });
      _fetchCurrentLocation();
    }
  }

  Future<void> saveLog() async {
    String url = 'https://ragroup.ind.in/api/mark_log_claim';
    String securityAuthenticationId = 'd347774d04690c2c5e7457a8a03e02e7';
    String securityToken = '2b45da5375d29a009023e25f27a2ddd4';
    String employeeId = user.employeeId ?? "0";
    String claimType = _selectedVehicle;
    String markLogLongitude = longitude.toString();
    String markLogLatitude = latitude.toString();
    String markLogAddress = _currentAddress;
    String markLogDistance = meter.toString();

    // Prepare the request body
    Map<String, dynamic> requestBody2 = {
      'security_authentication_id': securityAuthenticationId,
      'security_token': securityToken,
      'employee_id': employeeId,
      'claim_type': claimType,
      'mark_log_longitude': markLogLongitude,
      'mark_log_latitude': markLogLatitude,
      'mark_log_address': markLogAddress,
      'mark_log_distance': markLogDistance,
      'ticket_file': "",
    };
    print("marklog: " + requestBody2.toString());

    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(requestBody2),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      showMessage("Updated", false, context);
    } catch (e) {
      // Exception occurred during the request
      print('Error: $e');
    }
  }

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
        fetchLeaveDetails();
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  double meter = 0;
  Map checkClaimData = {};
  Future checkClaim() async {
    // ApiAccess().checkClaim(employeeId: user.employeeId!);
    checkClaimData = await ApiAccess().checkClaim(employeeId: user.employeeId!);
    // print(checkClaim);
    if (checkClaimData['claim'] == "1") {
      ping = "Mark Log";
    } else {
      ping = "End Trip";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: globalAppBar("Claim"),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          margin: const EdgeInsets.all(10),
          color: Colors.white,
          width: (width > 500) ? 500 : width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Select Type"), 
            // changed new line
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectVehicle('2 Wheeler'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedVehicle == '2 Wheeler'
                        ? AppColor.PRIMARY_COLOR
                        : AppColor.GREY_40,
                  ),
                  child: const Text(
                    '2 Wheeler',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectVehicle('4 Wheeler'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedVehicle == '4 Wheeler'
                        ? AppColor.PRIMARY_COLOR
                        : AppColor.GREY_40,
                  ),
                  child: const Text(
                    '4 Wheeler',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _selectVehicle('Transport'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedVehicle == 'Transport'
                        ? AppColor.PRIMARY_COLOR
                        : AppColor.GREY_40,
                  ),
                  child: const Text(
                    'Transport',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectVehicle('Others'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedVehicle == 'Others'
                        ? AppColor.PRIMARY_COLOR
                        : AppColor.GREY_40,
                  ),
                  child: const Text(
                    'Others',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
                visible: (_selectedVehicle == 'Transport' ||
                    _selectedVehicle == 'Others'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: const Text("Add Image"),
                    ),
                    InkWell(
                      onTap: () {
                        _takePictureAndConvertToBase64();
                      },
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: base64Image == ""
                                  ? AppColor.BORDER_COLOR
                                  : Colors.green,
                              width: 1.0,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 12, bottom: 12, right: 10),
                          child: Column(
                            children: [
                              Visibility(
                                visible: base64Image == "",
                                child: const Icon(Icons.add,
                                    color: AppColor.BORDER_COLOR),
                              ),
                              Visibility(
                                visible: base64Image != "",
                                child: const Icon(Icons.check_circle,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(), // Adding a border
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10), // Adjust padding
                          alignLabelWithHint:
                              true, // Align the label with the hint
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                          // Allowing only digits
                        ],
                        keyboardType: TextInputType.number,
                        // Show numeric keyboard
                        maxLines: 1, // This allows the field to be multiline
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Date",
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
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 366)))
                                .then((value) {
                              if (value != null) {
                                fromDate_ = value;
                                fromDate =
                                    DateFormat('dd/MM/yyyy').format(value);
                                fromDateShow =
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
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 0, right: 0),
                          child: TextFormField(
                            controller: reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Comment',
                              border: OutlineInputBorder(),
                              // Adding a border
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              // Adjust padding
                              alignLabelWithHint:
                                  true, // Align the label with the hint
                            ),
                            maxLines:
                                3, // This allows the field to be multiline
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  ],
                )),
            const SizedBox(height: 15),
            DAnimation(
                visible: _loading == false && ping != "",
                child: InkWell(
                  onTap: () {
                    sendClaim().then((value) => checkClaim());
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
                    child: Center(
                      child: Text(
                        ping ?? "",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }

  String fromDateShow = "--";
  String fromDate = "";
  DateTime fromDate_ = DateTime.now();
  bool _loading = false;

  void setInitDate() {
    fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fromDateShow = DateFormat('dd MMM yyyy').format(fromDate_);
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String _currentAddress = "";
  String base64Image = "";

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
      }
    }
  }

  getUser() {
    SharedPreferences.getInstance().then((value) async {
      var _data = value.getString(Userdetails);
      var j_data = jsonDecode(_data!);
      print("-----> $j_data");
      user = UserDetails.fromJson(j_data[0]);
      await checkClaim();
      setState(() {});
    });
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
}
