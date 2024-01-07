class UserDetails {
  String? errorCode;
  String? message;
  String? employeeId;
  String? empid;
  String? employeeName;
  String? employeeCompany;
  String? employeeDepartment;
  String? employeeDesignation;
  String? employeePhone;
  String? employeeEmail;
  String? employeeAddress;
  String? policeStation;
  String? state;
  String? district;
  String? city;
  String? pincode;
  String? employeePhoto;
  String? employeePan;

  UserDetails({
    this.errorCode,
    this.message,
    this.employeeId,
    this.empid,
    this.employeeName,
    this.employeeCompany,
    this.employeeDepartment,
    this.employeeDesignation,
    this.employeePhone,
    this.employeeEmail,
    this.employeeAddress,
    this.policeStation,
    this.state,
    this.district,
    this.city,
    this.pincode,
    this.employeePhoto,
    this.employeePan,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    message = json['message'];
    employeeId = json['employee_id'];
    empid = json['empid'];
    employeeName = json['employee_name'];
    employeeCompany = json['employee_company'];
    employeeDepartment = json['employee_department'];
    employeeDesignation = json['employee_designation'];
    employeePhone = json['employee_phone'];
    employeeEmail = json['employee_email'];
    employeeAddress = json['employee_address'];
    policeStation = json['police_station'];
    state = json['state'];
    district = json['district'];
    city = json['city'];
    pincode = json['pincode'];
    employeePhoto = json['employee_photo'];
    employeePan = json['employee_pan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = errorCode;
    data['message'] = message;
    data['employee_id'] = employeeId;
    data['empid'] = empid;
    data['employee_name'] = employeeName;
    data['employee_company'] = employeeCompany;
    data['employee_department'] = employeeDepartment;
    data['employee_designation'] = employeeDesignation;
    data['employee_phone'] = employeePhone;
    data['employee_email'] = employeeEmail;
    data['employee_address'] = employeeAddress;
    data['police_station'] = policeStation;
    data['state'] = state;
    data['district'] = district;
    data['city'] = city;
    data['pincode'] = pincode;
    data['employee_photo'] = employeePhoto;
    data['employee_pan'] = employeePan;
    return data;
  }
}
