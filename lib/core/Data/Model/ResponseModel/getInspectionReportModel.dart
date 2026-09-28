// To parse this JSON data, do
//
//     final getInspectionReportModel = getInspectionReportModelFromJson(jsonString);

import 'dart:convert';

GetInspectionReportModel getInspectionReportModelFromJson(String str) =>
    GetInspectionReportModel.fromJson(json.decode(str));

String getInspectionReportModelToJson(GetInspectionReportModel data) =>
    json.encode(data.toJson());

class GetInspectionReportModel {
  bool? status;
  List<Datum>? data;

  GetInspectionReportModel({this.status, this.data});

  factory GetInspectionReportModel.fromJson(Map<String, dynamic> json) =>
      GetInspectionReportModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? propertyId;
  int? inspectorId;
  String? reportType;
  dynamic auditType;
  DateTime? inspectionDate;
  String? findings;
  String? recommendations;
  String? score;
  String? status;
  Attachments? attachments;
  DateTime? createdAt;
  DateTime? updatedAt;
  Inspector? inspector;
  Property? property;

  Datum({
    this.id,
    this.propertyId,
    this.inspectorId,
    this.reportType,
    this.auditType,
    this.inspectionDate,
    this.findings,
    this.recommendations,
    this.score,
    this.status,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.inspector,
    this.property,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    propertyId: json["property_id"],
    inspectorId: json["inspector_id"],
    reportType: json["report_type"],
    auditType: json["audit_type"],
    inspectionDate: json["inspection_date"] == null
        ? null
        : DateTime.parse(json["inspection_date"]),
    findings: json["findings"],
    recommendations: json["recommendations"],
    score: json["score"]?.toString(),
    status: json["status"],
    attachments: json["attachments"] == null
        ? null
        : Attachments.fromJson(json["attachments"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    inspector: json["inspector"] == null
        ? null
        : Inspector.fromJson(json["inspector"]),
    property: json["property"] == null
        ? null
        : Property.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "inspector_id": inspectorId,
    "report_type": reportType,
    "audit_type": auditType,
    "inspection_date": inspectionDate?.toIso8601String(),
    "findings": findings,
    "recommendations": recommendations,
    "score": score,
    "status": status,
    "attachments": attachments?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "inspector": inspector?.toJson(),
    "property": property?.toJson(),
  };
}

class Attachments {
  String? pdf;
  List<String>? images;

  Attachments({this.pdf, this.images});

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
    pdf: json["pdf"]?.toString(),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "pdf": pdf,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class Inspector {
  int? id;
  String? name;
  String? email;
  String? role;
  String? phone;
  dynamic avatar;
  String? status;
  String? subscriptionStatus;
  dynamic fcmToken;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic unitId;

  Inspector({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.avatar,
    this.status,
    this.subscriptionStatus,
    this.fcmToken,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.unitId,
  });

  factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    phone: json["phone"],
    avatar: json["avatar"],
    status: json["status"],
    subscriptionStatus: json["subscription_status"],
    fcmToken: json["fcm_token"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    unitId: json["unit_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "phone": phone,
    "avatar": avatar,
    "status": status,
    "subscription_status": subscriptionStatus,
    "fcm_token": fcmToken,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "unit_id": unitId,
  };
}

class Property {
  int? id;
  int? complexId;
  int? complexUnitId;
  int? ownerId;
  dynamic caretakerId;
  String? propertyNameNumber;
  String? propertyType;
  String? image;
  String? location;
  String? area;
  String? status;
  String? carePackage;
  num? overallScore;
  DateTime? createdAt;
  DateTime? updatedAt;

  Property({
    this.id,
    this.complexId,
    this.complexUnitId,
    this.ownerId,
    this.caretakerId,
    this.propertyNameNumber,
    this.propertyType,
    this.image,
    this.location,
    this.area,
    this.status,
    this.carePackage,
    this.overallScore,
    this.createdAt,
    this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    complexId: json["complex_id"],
    complexUnitId: json["complex_unit_id"],
    ownerId: json["owner_id"],
    caretakerId: json["caretaker_id"],
    propertyNameNumber: json["property_name_number"],
    propertyType: json["property_type"],
    image: json["image"],
    location: json["location"],
    area: json["area"],
    status: json["status"],
    carePackage: json["care_package"],
    overallScore: json["overall_score"] == null
        ? null
        : (json["overall_score"] as num).toDouble(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "complex_id": complexId,
    "complex_unit_id": complexUnitId,
    "owner_id": ownerId,
    "caretaker_id": caretakerId,
    "property_name_number": propertyNameNumber,
    "property_type": propertyType,
    "image": image,
    "location": location,
    "area": area,
    "status": status,
    "care_package": carePackage,
    "overall_score": overallScore,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
