part of 'app_state_cubit.dart';

// @immutable
sealed class AppStateState {}

class AppStateInitial extends AppStateState {
  final int currentPage;
  final UserDetails? userDetails;
  AppStateInitial({
    this.currentPage = 0,
    this.userDetails,
  }) ;

  AppStateInitial copyWith({
    int? currentPage,
    UserDetails? userDetails,
  }) {
    return AppStateInitial(
      currentPage: currentPage ?? this.currentPage,
      userDetails: userDetails ?? this.userDetails,
    );
  }
}
