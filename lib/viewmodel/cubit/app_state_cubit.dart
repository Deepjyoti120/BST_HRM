import 'package:bsthrm/model/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_state_state.dart';

class AppStateCubit extends Cubit<AppStateInitial> {
  final BuildContext context;
  AppStateCubit({required this.context}) : super(AppStateInitial());
  int get currentPage => state.currentPage;
  UserDetails? get userDetails => state.userDetails;

  void clear() {
    currentPage = 0;
  }

  set currentPage(int currentPage) {
    emit(state.copyWith(currentPage: currentPage));
  }

  set userDetails(UserDetails? userDetails) {
    emit(state.copyWith(userDetails: userDetails));
  }
}
