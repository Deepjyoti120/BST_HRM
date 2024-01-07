class SalaryDetailsModel { 
  String? empid;
  String? employeeName;
  String? joiningDate;
  String? pan;
  String? designation;
  String? department;
  String? location;
  String? circle;
  String? state;
  String? bank;
  String? accNo;
  String? ifsc;
  String? pfNo;
  String? pfUan;
  String? esicNo;
  String? workDays;
  String? basicPay;
  String? hra;
  String? specialPay;
  String? variablePay;
  String? grossSalary;
  String? travellingAllowance;
  String? grossEarnings;
  String? employeePf;
  String? employeeEsi;
  String? tds;
  String? professionalTax;
  String? leaveDays;
  String? leaveDeduction;
  String? grossDeduction;
  String? netPay;

  SalaryDetailsModel({
    this.empid,
    this.employeeName,
    this.joiningDate,
    this.pan,
    this.designation,
    this.department,
    this.location,
    this.circle,
    this.state,
    this.bank,
    this.accNo,
    this.ifsc,
    this.pfNo,
    this.pfUan,
    this.esicNo,
    this.workDays,
    this.basicPay,
    this.hra,
    this.specialPay,
    this.variablePay,
    this.grossSalary,
    this.travellingAllowance,
    this.grossEarnings,
    this.employeePf,
    this.employeeEsi,
    this.tds,
    this.professionalTax,
    this.leaveDays,
    this.leaveDeduction,
    this.grossDeduction,
    this.netPay,
  });

  SalaryDetailsModel.fromJson(Map<String, dynamic> json) {
    empid = json['empid'] as String? ?? "";
    employeeName = json['employee_name'] as String? ?? "";
    joiningDate = json['joining_date'] as String? ?? "";
    pan = json['pan'] as String? ?? "";
    designation = json['designation'] as String? ?? "";
    department = json['department'] as String? ?? "";
    location = json['location'] as String? ?? "";
    circle = json['circle'] as String? ?? "";
    state = json['state'] as String? ?? "";
    bank = json['bank'] as String? ?? "";
    accNo = json['acc_no'] as String? ?? "";
    ifsc = json['ifsc'] as String? ?? "";
    pfNo = json['pf_no'] as String? ?? "";
    pfUan = json['pf_uan'] as String? ?? "";
    esicNo = json['esic_no'] as String? ?? "";
    workDays = json['work_days'] as String? ?? "";
    basicPay = json['basic_pay'] as String? ?? "";
    hra = json['hra'] as String? ?? "";
    specialPay = json['special_pay'] as String? ?? "";
    variablePay = json['variable_pay'] as String? ?? "";
    grossSalary = json['gross_salary'] as String? ?? "";
    travellingAllowance = json['travelling_allowance'] as String? ?? "";
    grossEarnings = json['gross_earnings'] as String? ?? "";
    employeePf = json['employee_pf'] as String? ?? "";
    employeeEsi = json['employee_esi'] as String? ?? "";
    tds = json['tds'] as String? ?? "";
    professionalTax = json['professional_tax'] as String? ?? "";
    leaveDays = json['leave_days'] as String? ?? "";
    leaveDeduction = json['leave_deduction'] as String? ?? "";
    grossDeduction = json['gross_deduction'] as String? ?? "";
    netPay = json['net_pay'] as String? ?? "";
  }
}
