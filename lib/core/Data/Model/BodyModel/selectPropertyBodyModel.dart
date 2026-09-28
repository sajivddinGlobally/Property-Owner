// To parse this JSON data, do
//
//     final selectPropertyBodyModel = selectPropertyBodyModelFromJson(jsonString);

import 'dart:convert';

SelectPropertyBodyModel selectPropertyBodyModelFromJson(String str) => SelectPropertyBodyModel.fromJson(json.decode(str));

String selectPropertyBodyModelToJson(SelectPropertyBodyModel data) => json.encode(data.toJson());

class SelectPropertyBodyModel {
    int? propertyId;

    SelectPropertyBodyModel({
        this.propertyId,
    });

    factory SelectPropertyBodyModel.fromJson(Map<String, dynamic> json) => SelectPropertyBodyModel(
        propertyId: json["property_id"],
    );

    Map<String, dynamic> toJson() => {
        "property_id": propertyId,
    };
}
