class KycSettingModel {
  final String? errorCode;
  final String? panVerification;
  final String? employeePanVerificationPanNo;
  final String? employeePanVerificationPanName;
  final String? employeePanCardFile;
  final String? bankVerification;
  final String? employeeBankVerificationAccNo;
  final String? employeeBankVerificationIfsc;
  final String? employeeBankVerificationAccHolderName;
  final String? employeeBankPassbookFile;
  final String? aadharVerification;
  final String? employeeAadharNo;
  final String? employeeAadharFullName;
  final String? employeeAadharDob;
  final String? employeeAadharGender;
  final String? employeeAadharCountry;
  final String? employeeAadharState;
  final String? employeeAadharPo;
  final String? employeeAadharLoc;
  final String? employeeAadharStreet;
  final String? employeeAadharHouse;
  final String? employeeAadharLandmark;
  final String? employeeAadharZip;
  final String? employeeAadharFile;

  KycSettingModel({
    this.errorCode,
    this.panVerification,
    this.employeePanVerificationPanNo,
    this.employeePanVerificationPanName,
    this.employeePanCardFile,
    this.bankVerification,
    this.employeeBankVerificationAccNo,
    this.employeeBankVerificationIfsc,
    this.employeeBankVerificationAccHolderName,
    this.employeeBankPassbookFile,
    this.aadharVerification,
    this.employeeAadharNo,
    this.employeeAadharFullName,
    this.employeeAadharDob,
    this.employeeAadharGender,
    this.employeeAadharCountry,
    this.employeeAadharState,
    this.employeeAadharPo,
    this.employeeAadharLoc,
    this.employeeAadharStreet,
    this.employeeAadharHouse,
    this.employeeAadharLandmark,
    this.employeeAadharZip,
    this.employeeAadharFile,
  });

  factory KycSettingModel.fromJson(Map<String, dynamic> json) {
    return KycSettingModel(
      errorCode: json['error_code']?.toString(),
      panVerification: json['pan_verification']?.toString(),
      employeePanVerificationPanNo:
          json['employee_pan_verification_pan_no']?.toString(),
      employeePanVerificationPanName:
          json['employee_pan_verification_pan_name']?.toString(),
      employeePanCardFile: json['employee_pan_card_file']?.toString(),
      bankVerification: json['bank_verification']?.toString(),
      employeeBankVerificationAccNo:
          json['employee_bank_verification_acc_no']?.toString(),
      employeeBankVerificationIfsc:
          json['employee_bank_verification_ifsc']?.toString(),
      employeeBankVerificationAccHolderName:
          json['employee_bank_verification_acc_holder_name']?.toString(),
      employeeBankPassbookFile: json['employee_bank_passbook_file']?.toString(),
      aadharVerification: json['aadhar_verification']?.toString(),
      employeeAadharNo: json['employee_aadhar_no']?.toString(),
      employeeAadharFullName: json['employee_aadhar_full_name']?.toString(),
      employeeAadharDob: json['employee_aadhar_dob']?.toString(),
      employeeAadharCountry: json['employee_aadhar_country']?.toString(),
      employeeAadharState: json['employee_aadhar_state']?.toString(),
      employeeAadharPo: json['employee_aadhar_po']?.toString(),
      employeeAadharLoc: json['employee_aadhar_loc']?.toString(),
      employeeAadharStreet: json['employee_aadhar_street']?.toString(),
      employeeAadharHouse: json['employee_aadhar_house']?.toString(),
      employeeAadharLandmark: json['employee_aadhar_landmark']?.toString(),
      employeeAadharZip: json['employee_aadhar_zip']?.toString(),
      employeeAadharFile: json['employee_aadhar_file']?.toString(),
    );
  }
  // to json 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error_code'] = errorCode;
    data['pan_verification'] = panVerification;
    data['employee_pan_verification_pan_no'] = employeePanVerificationPanNo;
    data['employee_pan_verification_pan_name'] =
        employeePanVerificationPanName;
    data['employee_pan_card_file'] = employeePanCardFile;
    data['bank_verification'] = bankVerification;
    data['employee_bank_verification_acc_no'] =
        employeeBankVerificationAccNo;
    data['employee_bank_verification_ifsc'] =
        employeeBankVerificationIfsc;
    data['employee_bank_verification_acc_holder_name'] =
        employeeBankVerificationAccHolderName;
    data['employee_bank_passbook_file'] = employeeBankPassbookFile;
    data['aadhar_verification'] = aadharVerification;
    data['employee_aadhar_no'] = employeeAadharNo;
    data['employee_aadhar_full_name'] = employeeAadharFullName;
    data['employee_aadhar_dob'] = employeeAadharDob;
    data['employee_aadhar_country'] = employeeAadharCountry;
    data['employee_aadhar_state'] = employeeAadharState;
    data['employee_aadhar_po'] = employeeAadharPo;
    data['employee_aadhar_loc'] = employeeAadharLoc;
    data['employee_aadhar_street'] = employeeAadharStreet;
    data['employee_aadhar_house'] = employeeAadharHouse;
    data['employee_aadhar_landmark'] = employeeAadharLandmark;
    data['employee_aadhar_zip'] = employeeAadharZip;
    data['employee_aadhar_file'] = employeeAadharFile;
    return data;
  }
}
