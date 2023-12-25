class EmployeeAttendance {
  String? employeeAttendanceId;
  String? officeIntime;
  String? officeOuttime;
  String? employeeAttendanceInTime;
  String? intimeAddress;
  String? intimeEarlyLate;
  String? employeeAttendanceOutTime;
  String? outtimeAddress;
  String? outtimeEarlyLate;
  String? employeeAttendanceDate;
  String? employeeAttendanceIntimePhoto;
  String? employeeAttendanceOuttimePhoto;
  String? employeeIntimeLongitude;
  String? employeeIntimeLatitude;
  String? employeeOuttimeLongitude;
  String? employeeOuttimeLatitude;

  EmployeeAttendance({
    required this.employeeAttendanceId,
    required this.officeIntime,
    required this.officeOuttime,
    required this.employeeAttendanceInTime,
    required this.intimeAddress,
    required this.intimeEarlyLate,
    required this.employeeAttendanceOutTime,
    required this.outtimeAddress,
    required this.outtimeEarlyLate,
    required this.employeeAttendanceDate,
    required this.employeeAttendanceIntimePhoto,
    required this.employeeAttendanceOuttimePhoto,
    required this.employeeIntimeLongitude,
    required this.employeeIntimeLatitude,
    required this.employeeOuttimeLongitude,
    required this.employeeOuttimeLatitude,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) {
    return EmployeeAttendance(
      employeeAttendanceId: json['employee_attendance_id'],
      officeIntime: json['office_intime'],
      officeOuttime: json['office_outtime'],
      employeeAttendanceInTime: json['employee_attendance_in_time'],
      intimeAddress: json['intime_address'],
      intimeEarlyLate: json['intime_early_late'],
      employeeAttendanceOutTime: json['employee_attendance_out_time'],
      outtimeAddress: json['outtime_address'],
      outtimeEarlyLate: json['outtime_early_late'],
      employeeAttendanceDate: json['employee_attendance_date'],
      employeeAttendanceIntimePhoto: json['employee_attendance_intime_photo'],
      employeeAttendanceOuttimePhoto: json['employee_attendance_outtime_photo'],
      employeeIntimeLongitude: json['employee_intime_longitude'],
      employeeIntimeLatitude:json['employee_intime_latitude'],
      employeeOuttimeLongitude: json['employee_outtime_longitude'],
      employeeOuttimeLatitude: json['employee_outtime_latitude'],
    );
  }
}
