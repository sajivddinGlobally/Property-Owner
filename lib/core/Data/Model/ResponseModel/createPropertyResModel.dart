// To parse this JSON data, do
//
//     final createPropertyResModel = createPropertyResModelFromJson(jsonString);

import 'dart:convert';

CreatePropertyResModel createPropertyResModelFromJson(String str) => CreatePropertyResModel.fromJson(json.decode(str));

String createPropertyResModelToJson(CreatePropertyResModel data) => json.encode(data.toJson());

class CreatePropertyResModel {
    bool? status;
    String? message;
    Data? data;

    CreatePropertyResModel({
        this.status,
        this.message,
        this.data,
    });

    factory CreatePropertyResModel.fromJson(Map<String, dynamic> json) => CreatePropertyResModel(
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
    int? id;
    int? complexId;
    dynamic complexUnitId;
    int? ownerId;
    dynamic caretakerId;
    String? propertyNameNumber;
    String? propertyType;
    dynamic image;
    dynamic location;
    dynamic area;
    String? status;
    String? carePackage;
    bool? hasMmc;
    String? monthlyMaintenanceFee;
    bool? isIndependent;
    double? overallScore;
    dynamic isSelected;
    DateTime? createdAt;
    DateTime? updatedAt;
    Complex? complex;
    Owner? owner;
    dynamic caretaker;

    Data({
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
        this.hasMmc,
        this.monthlyMaintenanceFee,
        this.isIndependent,
        this.overallScore,
        this.isSelected,
        this.createdAt,
        this.updatedAt,
        this.complex,
        this.owner,
        this.caretaker,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        hasMmc: json["has_mmc"],
        monthlyMaintenanceFee: json["monthly_maintenance_fee"],
        isIndependent: json["is_independent"],
        overallScore: json["overall_score"]?.toDouble(),
        isSelected: json["is_selected"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        caretaker: json["caretaker"],
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
        "has_mmc": hasMmc,
        "monthly_maintenance_fee": monthlyMaintenanceFee,
        "is_independent": isIndependent,
        "overall_score": overallScore,
        "is_selected": isSelected,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "complex": complex?.toJson(),
        "owner": owner?.toJson(),
        "caretaker": caretaker,
    };
}

class Complex {
    int? id;
    String? name;
    String? address;
    dynamic image;
    String? status;
    int? totalUnits;
    int? totalBlocks;
    dynamic associationHeadId;
    List<dynamic>? securityId;
    dynamic caretakerId;
    List<String>? facilities;
    DateTime? createdAt;
    DateTime? updatedAt;

    Complex({
        this.id,
        this.name,
        this.address,
        this.image,
        this.status,
        this.totalUnits,
        this.totalBlocks,
        this.associationHeadId,
        this.securityId,
        this.caretakerId,
        this.facilities,
        this.createdAt,
        this.updatedAt,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        image: json["image"],
        status: json["status"],
        totalUnits: json["total_units"],
        totalBlocks: json["total_blocks"],
        associationHeadId: json["association_head_id"],
        securityId: json["security_id"] == null ? [] : List<dynamic>.from(json["security_id"]!.map((x) => x)),
        caretakerId: json["caretaker_id"],
        facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
        "total_units": totalUnits,
        "total_blocks": totalBlocks,
        "association_head_id": associationHeadId,
        "security_id": securityId == null ? [] : List<dynamic>.from(securityId!.map((x) => x)),
        "caretaker_id": caretakerId,
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Owner {
    int? id;
    String? name;
    String? email;
    String? role;
    String? guardPost;
    int? isOnDuty;
    dynamic shiftId;
    String? phone;
    dynamic avatar;
    String? status;
    String? subscriptionStatus;
    dynamic fcmToken;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic unitId;

    Owner({
        this.id,
        this.name,
        this.email,
        this.role,
        this.guardPost,
        this.isOnDuty,
        this.shiftId,
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

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        guardPost: json["guard_post"],
        isOnDuty: json["is_on_duty"],
        shiftId: json["shift_id"],
        phone: json["phone"],
        avatar: json["avatar"],
        status: json["status"],
        subscriptionStatus: json["subscription_status"],
        fcmToken: json["fcm_token"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        unitId: json["unit_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "guard_post": guardPost,
        "is_on_duty": isOnDuty,
        "shift_id": shiftId,
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
