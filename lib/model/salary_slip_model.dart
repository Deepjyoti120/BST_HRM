class SalarySlipModel {
  String? salaryDate;
  String? month;
  String? year;
  String? salary; 

  SalarySlipModel({this.salaryDate, this.month, this.year, this.salary});

  SalarySlipModel.fromJson(Map<String, dynamic> json) {
    salaryDate = json['salary_date'];
    month = json['month'];
    year = json['year'];
    salary = json['salary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salary_date'] = this.salaryDate;
    data['month'] = this.month;
    data['year'] = this.year;
    data['salary'] = this.salary;
    return data;
  }
}