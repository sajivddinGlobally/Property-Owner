// To parse this JSON data, do
//
//     final registerBodyModel = registerBodyModelFromJson(jsonString);

import 'dart:convert';

RegisterBodyModel registerBodyModelFromJson(String str) => RegisterBodyModel.fromJson(json.decode(str));

String registerBodyModelToJson(RegisterBodyModel data) => json.encode(data.toJson());

class RegisterBodyModel {
    String? name;
    String? email;
    String? phone;
    String? password;
    String? role;
    String? confirmPassword;
    String? propertyNameNumber;

    RegisterBodyModel({
        this.name,
        this.email,
        this.phone,
        this.password,
        this.role,
        this.confirmPassword,
        this.propertyNameNumber,
    });

    factory RegisterBodyModel.fromJson(Map<String, dynamic> json) => RegisterBodyModel(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        role: json["role"],
        confirmPassword: json["confirm_password"],
        propertyNameNumber: json["property_name_number"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "role": role,
        "confirm_password": confirmPassword,
        "property_name_number": propertyNameNumber,
    };
}
