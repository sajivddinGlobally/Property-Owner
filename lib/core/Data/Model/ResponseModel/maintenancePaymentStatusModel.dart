// To parse this JSON data, do
//
//     final maintenancePaymentStatusModel = maintenancePaymentStatusModelFromJson(jsonString);

import 'dart:convert';

MaintenancePaymentStatusModel maintenancePaymentStatusModelFromJson(String str) => MaintenancePaymentStatusModel.fromJson(json.decode(str));

String maintenancePaymentStatusModelToJson(MaintenancePaymentStatusModel data) => json.encode(data.toJson());

class MaintenancePaymentStatusModel {
    bool? status;
    Data? data;

    MaintenancePaymentStatusModel({
        this.status,
        this.data,
    });

    factory MaintenancePaymentStatusModel.fromJson(Map<String, dynamic> json) => MaintenancePaymentStatusModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Property? property;
    CurrentStatus? currentStatus;
    List<dynamic>? monthlyRecords;
    Reminder? reminder;

    Data({
        this.property,
        this.currentStatus,
        this.monthlyRecords,
        this.reminder,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        property: json["property"] == null ? null : Property.fromJson(json["property"]),
        currentStatus: json["current_status"] == null ? null : CurrentStatus.fromJson(json["current_status"]),
        monthlyRecords: json["monthly_records"] == null ? [] : List<dynamic>.from(json["monthly_records"]!.map((x) => x)),
        reminder: json["reminder"] == null ? null : Reminder.fromJson(json["reminder"]),
    );

    Map<String, dynamic> toJson() => {
        "property": property?.toJson(),
        "current_status": currentStatus?.toJson(),
        "monthly_records": monthlyRecords == null ? [] : List<dynamic>.from(monthlyRecords!.map((x) => x)),
        "reminder": reminder?.toJson(),
    };
}

class CurrentStatus {
    int? monthlyCharge;
    String? formattedMonthlyCharge;
    String? dueDate;
    String? paymentStatus;
    String? defaulterStatus;
    bool? isDefaulter;
    String? lastUpdated;

    CurrentStatus({
        this.monthlyCharge,
        this.formattedMonthlyCharge,
        this.dueDate,
        this.paymentStatus,
        this.defaulterStatus,
        this.isDefaulter,
        this.lastUpdated,
    });

    factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
        monthlyCharge: json["monthly_charge"],
        formattedMonthlyCharge: json["formatted_monthly_charge"],
        dueDate: json["due_date"],
        paymentStatus: json["payment_status"],
        defaulterStatus: json["defaulter_status"],
        isDefaulter: json["is_defaulter"],
        lastUpdated: json["last_updated"],
    );

    Map<String, dynamic> toJson() => {
        "monthly_charge": monthlyCharge,
        "formatted_monthly_charge": formattedMonthlyCharge,
        "due_date": dueDate,
        "payment_status": paymentStatus,
        "defaulter_status": defaulterStatus,
        "is_defaulter": isDefaulter,
        "last_updated": lastUpdated,
    };
}

class Property {
    int? id;
    String? name;
    String? complexName;
    String? badgeStatus;
    int? outstandingAmount;
    String? formattedOutstanding;

    Property({
        this.id,
        this.name,
        this.complexName,
        this.badgeStatus,
        this.outstandingAmount,
        this.formattedOutstanding,
    });

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        complexName: json["complex_name"],
        badgeStatus: json["badge_status"],
        outstandingAmount: json["outstanding_amount"],
        formattedOutstanding: json["formatted_outstanding"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "complex_name": complexName,
        "badge_status": badgeStatus,
        "outstanding_amount": outstandingAmount,
        "formatted_outstanding": formattedOutstanding,
    };
}

class Reminder {
    bool? show;
    String? title;
    String? message;

    Reminder({
        this.show,
        this.title,
        this.message,
    });

    factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        show: json["show"],
        title: json["title"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "show": show,
        "title": title,
        "message": message,
    };
}
