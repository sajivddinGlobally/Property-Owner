// To parse this JSON data, do
//
//     final registerResModel = registerResModelFromJson(jsonString);

import 'dart:convert';

RegisterResModel registerResModelFromJson(String str) => RegisterResModel.fromJson(json.decode(str));

String registerResModelToJson(RegisterResModel data) => json.encode(data.toJson());

class RegisterResModel {
    bool? status;
    String? message;
    Data? data;

    RegisterResModel({
        this.status,
        this.message,
        this.data,
    });

    factory RegisterResModel.fromJson(Map<String, dynamic> json) => RegisterResModel(
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
    User? user;
    String? token;
    String? tokenType;

    Data({
        this.user,
        this.token,
        this.tokenType,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
        tokenType: json["token_type"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "token_type": tokenType,
    };
}

class User {
    String? name;
    String? email;
    String? phone;
    String? role;
    String? status;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    User({
        this.name,
        this.email,
        this.phone,
        this.role,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
