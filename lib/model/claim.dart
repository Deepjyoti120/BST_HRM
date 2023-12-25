class Claim {
  String claimType;
  int totalDistance;
  int perKmCharge;
  String claimDocs;
  String claimAmount;
  String claimDate;
  String status;
  String approveRejectionTime;
  String approveRejectionById;
  String approveRejectionByName;
  List<MarkLog> markLog;

  Claim({
    required this.claimType,
    required this.totalDistance,
    required this.perKmCharge,
    required this.claimDocs,
    required this.claimAmount,
    required this.claimDate,
    required this.status,
    required this.approveRejectionTime,
    required this.approveRejectionById,
    required this.approveRejectionByName,
    required this.markLog,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      claimType: json['claim_type'] ?? '',
      totalDistance: json['total_distance'] ?? 0,
      perKmCharge: json['per_km_charge'] ?? 0,
      claimDocs: json['claim_docs'] ?? '',
      claimAmount: json['claim_amount'] ?? '0',
      claimDate: json['claim_date'] ?? '',
      status: json['status'] ?? '',
      approveRejectionTime: json['approve_rejection_time'] ?? '',
      approveRejectionById: json['approve_rejection_by_id'] ?? '',
      approveRejectionByName: json['approve_rejection_by_name'] ?? '',
      markLog: (json['mark_log'] as List)
          .map((e) => MarkLog.fromJson(e))
          .toList(),
    );
  }
}

class MarkLog {
  String markLogTime;
  String markLogLongitude;
  String markLogLatitude;
  String markLogAddress;
  String markLogDistance;

  MarkLog({
    required this.markLogTime,
    required this.markLogLongitude,
    required this.markLogLatitude,
    required this.markLogAddress,
    required this.markLogDistance,
  });

  factory MarkLog.fromJson(Map<String, dynamic> json) {
    return MarkLog(
      markLogTime: json['mark_log_time'] ?? '',
      markLogLongitude: json['mark_log_longitude'] ?? '',
      markLogLatitude: json['mark_log_latitude'] ?? '',
      markLogAddress: json['mark_log_address'] ?? '',
      markLogDistance: json['mark_log_distance'] ?? '',
    );
  }
}