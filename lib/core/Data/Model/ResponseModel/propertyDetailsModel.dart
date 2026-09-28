// To parse this JSON data, do
//
//     final propertyDetailsModel = propertyDetailsModelFromJson(jsonString);

import 'dart:convert';

PropertyDetailsModel propertyDetailsModelFromJson(String str) =>
    PropertyDetailsModel.fromJson(json.decode(str));

String propertyDetailsModelToJson(PropertyDetailsModel data) =>
    json.encode(data.toJson());

class PropertyDetailsModel {
  bool? status;
  Data? data;

  PropertyDetailsModel({this.status, this.data});

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) =>
      PropertyDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? id;
  String? propertyNameNumber;
  String? propertyType;
  String? location;
  String? area;
  String? status;
  String? imageUrl;
  String? carePackage;
  String? carePackageLabel;
  double? overallScore;
  double? overallScoreOutOf10;
  bool? isIndependent;
  bool? hasMmc;
  dynamic caretaker;
  Complex? complex;
  Widgets? widgets;

  Data({
    this.id,
    this.propertyNameNumber,
    this.propertyType,
    this.location,
    this.area,
    this.status,
    this.imageUrl,
    this.carePackage,
    this.carePackageLabel,
    this.overallScore,
    this.overallScoreOutOf10,
    this.isIndependent,
    this.hasMmc,
    this.caretaker,
    this.complex,
    this.widgets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    propertyNameNumber: json["property_name_number"],
    propertyType: json["property_type"],
    location: json["location"],
    area: json["area"],
    status: json["status"],
    imageUrl: json["image_url"],
    carePackage: json["care_package"],
    carePackageLabel: json["care_package_label"],
    overallScore: json["overall_score"]?.toDouble(),
    overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
    isIndependent: json["is_independent"],
    hasMmc: json["has_mmc"],
    caretaker: json["caretaker"],
    complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
    widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name_number": propertyNameNumber,
    "property_type": propertyType,
    "location": location,
    "area": area,
    "status": status,
    "image_url": imageUrl,
    "care_package": carePackage,
    "care_package_label": carePackageLabel,
    "overall_score": overallScore,
    "overall_score_out_of_10": overallScoreOutOf10,
    "is_independent": isIndependent,
    "has_mmc": hasMmc,
    "caretaker": caretaker,
    "complex": complex?.toJson(),
    "widgets": widgets?.toJson(),
  };
}

class Complex {
  int? id;
  String? name;
  String? address;
  List<String>? facilities;

  Complex({this.id, this.name, this.address, this.facilities});

  factory Complex.fromJson(Map<String, dynamic> json) => Complex(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    facilities: json["facilities"] == null
        ? []
        : List<String>.from(json["facilities"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "facilities": facilities == null
        ? []
        : List<dynamic>.from(facilities!.map((x) => x)),
  };
}

class Widgets {
  int? pendingIssues;
  Complaints? serviceRequests;
  Complaints? complaints;
  MaintenancePayment? maintenancePayment;
  int? openMaintenance;
  int? documentsCount;
  LatestInspection? latestInspection;
  dynamic latestAudit;

  Widgets({
    this.pendingIssues,
    this.serviceRequests,
    this.complaints,
    this.maintenancePayment,
    this.openMaintenance,
    this.documentsCount,
    this.latestInspection,
    this.latestAudit,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
    pendingIssues: json["pending_issues"],
    serviceRequests: json["service_requests"] == null
        ? null
        : Complaints.fromJson(json["service_requests"]),
    complaints: json["complaints"] == null
        ? null
        : Complaints.fromJson(json["complaints"]),
    maintenancePayment: json["maintenance_payment"] == null
        ? null
        : MaintenancePayment.fromJson(json["maintenance_payment"]),
    openMaintenance: json["open_maintenance"],
    documentsCount: json["documents_count"],
    latestInspection: json["latest_inspection"] == null
        ? null
        : LatestInspection.fromJson(json["latest_inspection"]),
    latestAudit: json["latest_audit"],
  );

  Map<String, dynamic> toJson() => {
    "pending_issues": pendingIssues,
    "service_requests": serviceRequests?.toJson(),
    "complaints": complaints?.toJson(),
    "maintenance_payment": maintenancePayment?.toJson(),
    "open_maintenance": openMaintenance,
    "documents_count": documentsCount,
    "latest_inspection": latestInspection?.toJson(),
    "latest_audit": latestAudit,
  };
}

class Complaints {
  int? active;
  int? inProgress;

  Complaints({this.active, this.inProgress});

  factory Complaints.fromJson(Map<String, dynamic> json) =>
      Complaints(active: json["active"], inProgress: json["in_progress"]);

  Map<String, dynamic> toJson() => {
    "active": active,
    "in_progress": inProgress,
  };
}

class LatestInspection {
  int? id;
  DateTime? date;
  double? score;
  String? status;

  LatestInspection({this.id, this.date, this.score, this.status});

  factory LatestInspection.fromJson(Map<String, dynamic> json) =>
      LatestInspection(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        score: json["score"]?.toDouble(),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "score": score,
    "status": status,
  };
}

class MaintenancePayment {
  bool? isApplicable;
  String? status;
  String? reason;
  String? message;
  int? outstanding;
  int? upcoming;
  int? overdue;
  int? remaining;

  MaintenancePayment({
    this.isApplicable,
    this.status,
    this.reason,
    this.message,
    this.outstanding,
    this.upcoming,
    this.overdue,
    this.remaining,
  });

  factory MaintenancePayment.fromJson(Map<String, dynamic> json) =>
      MaintenancePayment(
        isApplicable: json["is_applicable"],
        status: json["status"],
        reason: json["reason"],
        message: json["message"],
        outstanding: json["outstanding"],
        upcoming: json["upcoming"],
        overdue: json["overdue"],
        remaining: json["remaining"],
      );

  Map<String, dynamic> toJson() => {
    "is_applicable": isApplicable,
    "status": status,
    "reason": reason,
    "message": message,
    "outstanding": outstanding,
    "upcoming": upcoming,
    "overdue": overdue,
    "remaining": remaining,
  };
}
