// To parse this JSON data, do
//
//     final closeBodyModel = closeBodyModelFromJson(jsonString);

import 'dart:convert';

CloseBodyModel closeBodyModelFromJson(String str) => CloseBodyModel.fromJson(json.decode(str));

String closeBodyModelToJson(CloseBodyModel data) => json.encode(data.toJson());

class CloseBodyModel {
    String? status;
    String? notes;

    CloseBodyModel({
        this.status,
        this.notes,
    });

    factory CloseBodyModel.fromJson(Map<String, dynamic> json) => CloseBodyModel(
        status: json["status"],
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "notes": notes,
    };
}
