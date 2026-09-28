// To parse this JSON data, do
//
//     final getUtilityStatusModel = getUtilityStatusModelFromJson(jsonString);

import 'dart:convert';

GetUtilityStatusModel getUtilityStatusModelFromJson(String str) =>
    GetUtilityStatusModel.fromJson(json.decode(str));

String getUtilityStatusModelToJson(GetUtilityStatusModel data) =>
    json.encode(data.toJson());

class GetUtilityStatusModel {
  bool? status;
  Data? data;

  GetUtilityStatusModel({
    this.status,
    this.data,
  });

  factory GetUtilityStatusModel.fromJson(Map<String, dynamic> json) =>
      GetUtilityStatusModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Header? header;
  PropertyDetails? propertyDetails;
  Summary? summary;
  List<CurrentUtilityStatus>? currentUtilityStatus;
  List<UtilityPaymentHistory>? utilityPaymentHistory;
  Reminder? reminder;

  Data({
    this.header,
    this.propertyDetails,
    this.summary,
    this.currentUtilityStatus,
    this.utilityPaymentHistory,
    this.reminder,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        propertyDetails: json["property_details"] == null
            ? null
            : PropertyDetails.fromJson(json["property_details"]),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        currentUtilityStatus: json["current_utility_status"] == null
            ? []
            : List<CurrentUtilityStatus>.from(
                json["current_utility_status"]!.map(
                  (x) => CurrentUtilityStatus.fromJson(x),
                ),
              ),
        utilityPaymentHistory: json["utility_payment_history"] == null
            ? []
            : List<UtilityPaymentHistory>.from(
                json["utility_payment_history"]!.map(
                  (x) => UtilityPaymentHistory.fromJson(x),
                ),
              ),
        reminder: json["reminder"] == null
            ? null
            : Reminder.fromJson(json["reminder"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "property_details": propertyDetails?.toJson(),
        "summary": summary?.toJson(),
        "current_utility_status": currentUtilityStatus == null
            ? []
            : List<dynamic>.from(currentUtilityStatus!.map((x) => x.toJson())),
        "utility_payment_history": utilityPaymentHistory == null
            ? []
            : List<dynamic>.from(utilityPaymentHistory!.map((x) => x.toJson())),
        "reminder": reminder?.toJson(),
      };
}

class Header {
  String? screenTitle;
  String? subtitle;

  Header({
    this.screenTitle,
    this.subtitle,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        screenTitle: json["screen_title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "screen_title": screenTitle,
        "subtitle": subtitle,
      };
}

class PropertyDetails {
  dynamic propertyId;
  String? propertyName;
  String? complexName;
  String? status;

  PropertyDetails({
    this.propertyId,
    this.propertyName,
    this.complexName,
    this.status,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
      PropertyDetails(
        propertyId: json["property_id"],
        propertyName: json["property_name"],
        complexName: json["complex_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "property_id": propertyId,
        "property_name": propertyName,
        "complex_name": complexName,
        "status": status,
      };
}

class Summary {
  dynamic totalOutstanding;
  String? description;
  String? currentMonth;
  dynamic pendingBillsCount;

  Summary({
    this.totalOutstanding,
    this.description,
    this.currentMonth,
    this.pendingBillsCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalOutstanding: json["total_outstanding"],
        description: json["description"],
        currentMonth: json["current_month"],
        pendingBillsCount: json["pending_bills_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_outstanding": totalOutstanding,
        "description": description,
        "current_month": currentMonth,
        "pending_bills_count": pendingBillsCount,
      };
}

class CurrentUtilityStatus {
  dynamic id;
  String? utilityType;
  String? title;
  dynamic amount;
  String? dueDate;
  String? status;
  String? badge;

  CurrentUtilityStatus({
    this.id,
    this.utilityType,
    this.title,
    this.amount,
    this.dueDate,
    this.status,
    this.badge,
  });

  factory CurrentUtilityStatus.fromJson(Map<String, dynamic> json) =>
      CurrentUtilityStatus(
        id: json["id"],
        utilityType: json["utility_type"],
        title: json["title"],
        amount: json["amount"],
        dueDate: json["due_date"],
        status: json["status"],
        badge: json["badge"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "utility_type": utilityType,
        "title": title,
        "amount": amount,
        "due_date": dueDate,
        "status": status,
        "badge": badge,
      };
}

class UtilityPaymentHistory {
  String? month;
  String? label;
  dynamic amount;
  dynamic totalAmount;
  String? status;
  String? badge;

  UtilityPaymentHistory({
    this.month,
    this.label,
    this.amount,
    this.totalAmount,
    this.status,
    this.badge,
  });

  factory UtilityPaymentHistory.fromJson(Map<String, dynamic> json) =>
      UtilityPaymentHistory(
        month: json["month"],
        label: json["label"],
        amount: json["amount"],
        totalAmount: json["total_amount"],
        status: json["status"],
        badge: json["badge"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "label": label,
        "amount": amount,
        "total_amount": totalAmount,
        "status": status,
        "badge": badge,
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
