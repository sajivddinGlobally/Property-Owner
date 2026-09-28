// To parse this JSON data, do
//
//     final getTenantPaymentModel = getTenantPaymentModelFromJson(jsonString);

import 'dart:convert';

GetTenantPaymentModel getTenantPaymentModelFromJson(String str) => GetTenantPaymentModel.fromJson(json.decode(str));

String getTenantPaymentModelToJson(GetTenantPaymentModel data) => json.encode(data.toJson());

class GetTenantPaymentModel {
    bool? status;
    Data? data;

    GetTenantPaymentModel({
        this.status,
        this.data,
    });

    factory GetTenantPaymentModel.fromJson(Map<String, dynamic> json) => GetTenantPaymentModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    String? tenantName;
    dynamic tenantImageUrl;
    String? tenantType;
    String? tenantStatus;
    String? propertyName;
    String? currentOutstanding;
    String? monthlyRent;
    String? dueDate;
    CurrentRentStatus? currentRentStatus;
    List<RentPaymentHistory>? rentPaymentHistory;

    Data({
        this.tenantName,
        this.tenantImageUrl,
        this.tenantType,
        this.tenantStatus,
        this.propertyName,
        this.currentOutstanding,
        this.monthlyRent,
        this.dueDate,
        this.currentRentStatus,
        this.rentPaymentHistory,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        tenantName: json["tenant_name"],
        tenantImageUrl: json["tenant_image_url"],
        tenantType: json["tenant_type"],
        tenantStatus: json["tenant_status"],
        propertyName: json["property_name"],
        currentOutstanding: json["current_outstanding"],
        monthlyRent: json["monthly_rent"],
        dueDate: json["due_date"],
        currentRentStatus: json["current_rent_status"] == null ? null : CurrentRentStatus.fromJson(json["current_rent_status"]),
        rentPaymentHistory: json["rent_payment_history"] == null ? [] : List<RentPaymentHistory>.from(json["rent_payment_history"]!.map((x) => RentPaymentHistory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tenant_name": tenantName,
        "tenant_image_url": tenantImageUrl,
        "tenant_type": tenantType,
        "tenant_status": tenantStatus,
        "property_name": propertyName,
        "current_outstanding": currentOutstanding,
        "monthly_rent": monthlyRent,
        "due_date": dueDate,
        "current_rent_status": currentRentStatus?.toJson(),
        "rent_payment_history": rentPaymentHistory == null ? [] : List<dynamic>.from(rentPaymentHistory!.map((x) => x.toJson())),
    };
}

class CurrentRentStatus {
    String? month;
    String? rentAmount;
    String? dueDate;
    String? paymentStatus;
    String? lastPayment;

    CurrentRentStatus({
        this.month,
        this.rentAmount,
        this.dueDate,
        this.paymentStatus,
        this.lastPayment,
    });

    factory CurrentRentStatus.fromJson(Map<String, dynamic> json) => CurrentRentStatus(
        month: json["month"],
        rentAmount: json["rent_amount"],
        dueDate: json["due_date"],
        paymentStatus: json["payment_status"],
        lastPayment: json["last_payment"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "rent_amount": rentAmount,
        "due_date": dueDate,
        "payment_status": paymentStatus,
        "last_payment": lastPayment,
    };
}

class RentPaymentHistory {
    String? month;
    String? rentAmount;
    String? dueDate;
    dynamic paidOn;
    String? status;
    int? paymentId;

    RentPaymentHistory({
        this.month,
        this.rentAmount,
        this.dueDate,
        this.paidOn,
        this.status,
        this.paymentId,
    });

    factory RentPaymentHistory.fromJson(Map<String, dynamic> json) => RentPaymentHistory(
        month: json["month"],
        rentAmount: json["rent_amount"],
        dueDate: json["due_date"],
        paidOn: json["paid_on"],
        status: json["status"],
        paymentId: json["payment_id"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "rent_amount": rentAmount,
        "due_date": dueDate,
        "paid_on": paidOn,
        "status": status,
        "payment_id": paymentId,
    };
}
