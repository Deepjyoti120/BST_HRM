import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;



Future<http.Response> postAPI(var postObject, API_URL) async {
  print("postAPI: " + postObject.toString() + " / " + API_URL);
  final response = await http.post(Uri.parse(API_URL),
      headers: {"Content-type": "application/json"}, body: jsonEncode(postObject));
  return response;
}
Map<String, String> postObject(
    Map<String, String> variables,
    ) {
  Map<String, String> loginData = {
    'security_authentication_id': "d347774d04690c2c5e7457a8a03e02e7",
    'security_token': "2b45da5375d29a009023e25f27a2ddd4",
  };

  loginData.addAll(variables);

  return loginData;
}