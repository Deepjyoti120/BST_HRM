// i use get package for state management
import 'package:bsthrm/model/user_details.dart';
import 'package:get/get.dart';

class GetState {
  Rx<UserDetails> userDetails = UserDetails().obs;
}