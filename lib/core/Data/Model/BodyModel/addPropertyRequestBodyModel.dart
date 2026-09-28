// To parse this JSON data, do
//
//     final addPropertyRequestBodyModel = addPropertyRequestBodyModelFromJson(jsonString);

import 'dart:convert';

AddPropertyRequestBodyModel addPropertyRequestBodyModelFromJson(String str) => AddPropertyRequestBodyModel.fromJson(json.decode(str));

String addPropertyRequestBodyModelToJson(AddPropertyRequestBodyModel data) => json.encode(data.toJson());

class AddPropertyRequestBodyModel {
    String? propertyNameNumber;
    String? propertyType;
    String? location;
    String? area;
    String? carePackage;
    String? complexes;

    AddPropertyRequestBodyModel({
        this.propertyNameNumber,
        this.propertyType,
        this.location,
        this.area,
        this.carePackage,
        this.complexes,
    });

    factory AddPropertyRequestBodyModel.fromJson(Map<String, dynamic> json) => AddPropertyRequestBodyModel(
        propertyNameNumber: json["property_name_number"],
        propertyType: json["property_type"],
        location: json["location"],
        area: json["area"],
        carePackage: json["care_package"],
        complexes: json["complexes"],
    );

    Map<String, dynamic> toJson() => {
        "property_name_number": propertyNameNumber,
        "property_type": propertyType,
        "location": location,
        "area": area,
        "care_package": carePackage,
        "complexes": complexes,
    };
}
