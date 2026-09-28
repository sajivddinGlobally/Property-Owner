// To parse this JSON data, do
//
//     final availableFlatsModel = availableFlatsModelFromJson(jsonString);

import 'dart:convert';

AvailableFlatsModel availableFlatsModelFromJson(String str) => AvailableFlatsModel.fromJson(json.decode(str));

String availableFlatsModelToJson(AvailableFlatsModel data) => json.encode(data.toJson());

class AvailableFlatsModel {
    bool? status;
    String? message;
    List<Datum>? data;

    AvailableFlatsModel({
        this.status,
        this.message,
        this.data,
    });

    factory AvailableFlatsModel.fromJson(Map<String, dynamic> json) => AvailableFlatsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    int? complexId;
    String? propertyNameNumber;
    String? propertyType;
    String? location;
    String? status;
    Complex? complex;

    Datum({
        this.id,
        this.complexId,
        this.propertyNameNumber,
        this.propertyType,
        this.location,
        this.status,
        this.complex,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        complexId: json["complex_id"],
        propertyNameNumber: json["property_name_number"],
        propertyType: json["property_type"],
        location: json["location"],
        status: json["status"],
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "complex_id": complexId,
        "property_name_number": propertyNameNumber,
        "property_type": propertyType,
        "location": location,
        "status": status,
        "complex": complex?.toJson(),
    };
}

class Complex {
    int? id;
    String? name;

    Complex({
        this.id,
        this.name,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
