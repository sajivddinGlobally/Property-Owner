// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
    bool? status;
    Data? data;

    GetProfileModel({
        this.status,
        this.data,
    });

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? role;
    String? phone;
    String? avatar;
    String? status;
    String? subscriptionStatus;
    dynamic fcmToken;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic unitId;
    String? avatarUrl;
    ActiveProperty? activeProperty;

    Data({
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
        this.avatarUrl,
        this.activeProperty,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        unitId: json["unit_id"],
        avatarUrl: json["avatar_url"],
        activeProperty: json["active_property"] == null ? null : ActiveProperty.fromJson(json["active_property"]),
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
        "avatar_url": avatarUrl,
        "active_property": activeProperty?.toJson(),
    };
}

class ActiveProperty {
    int? id;
    String? propertyNameNumber;
    String? propertyType;
    String? status;
    String? area;
    String? ownership;
    String? complexName;

    ActiveProperty({
        this.id,
        this.propertyNameNumber,
        this.propertyType,
        this.status,
        this.area,
        this.ownership,
        this.complexName,
    });

    factory ActiveProperty.fromJson(Map<String, dynamic> json) => ActiveProperty(
        id: json["id"],
        propertyNameNumber: json["property_name_number"],
        propertyType: json["property_type"],
        status: json["status"],
        area: json["area"],
        ownership: json["ownership"],
        complexName: json["complex_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property_name_number": propertyNameNumber,
        "property_type": propertyType,
        "status": status,
        "area": area,
        "ownership": ownership,
        "complex_name": complexName,
    };
}
