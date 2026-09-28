// To parse this JSON data, do
//
//     final propertyListModel = propertyListModelFromJson(jsonString);

import 'dart:convert';

PropertyListModel propertyListModelFromJson(String str) =>
    PropertyListModel.fromJson(json.decode(str));

String propertyListModelToJson(PropertyListModel data) =>
    json.encode(data.toJson());

class PropertyListModel {
  bool? status;
  List<Datum>? data;

  PropertyListModel({
    this.status,
    this.data,
  });

  factory PropertyListModel.fromJson(Map<String, dynamic> json) =>
      PropertyListModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                json["data"].map(
                  (x) => Datum.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(
                data!.map(
                  (x) => x.toJson(),
                ),
              ),
      };
}

class Datum {
  int? id;
  String? propertyNameNumber;
  String? propertyType;
  String? location;
  String? area;
  String? status;
  String? imageUrl;
  String? carePackage;
  num? overallScore;
  bool? isSelected;
  String? complexName;

  Datum({
    this.id,
    this.propertyNameNumber,
    this.propertyType,
    this.location,
    this.area,
    this.status,
    this.imageUrl,
    this.carePackage,
    this.overallScore,
    this.isSelected,
    this.complexName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        propertyNameNumber: json["property_name_number"],
        propertyType: json["property_type"],
        location: json["location"],
        area: json["area"],
        status: json["status"],
        imageUrl: json["image_url"],
        carePackage: json["care_package"],
        overallScore: json["overall_score"] == null
            ? null
            : (json["overall_score"] as num).toDouble(),
        isSelected: json["is_selected"],
        complexName: json["complex_name"],
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
        "overall_score": overallScore,
        "is_selected": isSelected,
        "complex_name": complexName,
      };
}