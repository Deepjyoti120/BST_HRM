import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // backgroundColor: Colors.green,
      // textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
