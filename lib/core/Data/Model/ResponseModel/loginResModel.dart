// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

LoginResModel loginResModelFromJson(String str) =>
    LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
  bool? status;
  String? message;
  Data? data;

  LoginResModel({this.status, this.message, this.data});

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
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
  int? expiresIn;
  String? propertyNameNumber;

  Data({
    this.user,
    this.token,
    this.tokenType,
    this.expiresIn,
    this.propertyNameNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    propertyNameNumber:
        json["property_name_number"] ?? json["user"]?["property_name_number"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "property_name_number": propertyNameNumber,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? status;
  String? propertyNameNumber;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.status,
    this.propertyNameNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    status: json["status"],
    propertyNameNumber: json["property_name_number"] ?? json["flat_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
    "status": status,
    "property_name_number": propertyNameNumber,
  };
}
