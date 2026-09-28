// To parse this JSON data, do
//
//     final addPropertyRequestResModel = addPropertyRequestResModelFromJson(jsonString);

import 'dart:convert';

AddPropertyRequestResModel addPropertyRequestResModelFromJson(String str) =>
    AddPropertyRequestResModel.fromJson(json.decode(str));

String addPropertyRequestResModelToJson(AddPropertyRequestResModel data) =>
    json.encode(data.toJson());

class AddPropertyRequestResModel {
  bool? status;
  String? message;
  Data? data;

  AddPropertyRequestResModel({this.status, this.message, this.data});

  factory AddPropertyRequestResModel.fromJson(Map<String, dynamic> json) =>
      AddPropertyRequestResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? ownerId;
  dynamic complexId;
  String? propertyNameNumber;
  String? propertyType;
  String? location;
  String? area;
  String? carePackage;
  String? status;
  String? overallScore;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.ownerId,
    this.complexId,
    this.propertyNameNumber,
    this.propertyType,
    this.location,
    this.area,
    this.carePackage,
    this.status,
    this.overallScore,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ownerId: json["owner_id"],
    complexId: json["complex_id"],
    propertyNameNumber: json["property_name_number"],
    propertyType: json["property_type"],
    location: json["location"],
    area: json["area"],
    carePackage: json["care_package"],
    status: json["status"],
    overallScore: json["overall_score"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "owner_id": ownerId,
    "complex_id": complexId,
    "property_name_number": propertyNameNumber,
    "property_type": propertyType,
    "location": location,
    "area": area,
    "care_package": carePackage,
    "status": status,
    "overall_score": overallScore,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
