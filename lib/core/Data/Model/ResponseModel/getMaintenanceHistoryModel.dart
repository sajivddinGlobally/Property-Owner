// To parse this JSON data, do
//
//     final getMaintenanceHistoryModel = getMaintenanceHistoryModelFromJson(jsonString);

import 'dart:convert';

GetMaintenanceHistoryModel getMaintenanceHistoryModelFromJson(String str) => GetMaintenanceHistoryModel.fromJson(json.decode(str));

String getMaintenanceHistoryModelToJson(GetMaintenanceHistoryModel data) => json.encode(data.toJson());

class GetMaintenanceHistoryModel {
    bool? status;
    Data? data;

    GetMaintenanceHistoryModel({
        this.status,
        this.data,
    });

    factory GetMaintenanceHistoryModel.fromJson(Map<String, dynamic> json) => GetMaintenanceHistoryModel(
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
    List<String>? filterOptions;
    String? activeFilter;
    List<Record>? records;

    Data({
        this.property,
        this.filterOptions,
        this.activeFilter,
        this.records,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        property: json["property"] == null ? null : Property.fromJson(json["property"]),
        filterOptions: json["filter_options"] == null ? [] : List<String>.from(json["filter_options"]!.map((x) => x)),
        activeFilter: json["active_filter"],
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "property": property?.toJson(),
        "filter_options": filterOptions == null ? [] : List<dynamic>.from(filterOptions!.map((x) => x)),
        "active_filter": activeFilter,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
    };
}

class Property {
    int? id;
    String? name;
    String? complexName;
    String? status;
    int? totalRecords;
    int? completedRecords;

    Property({
        this.id,
        this.name,
        this.complexName,
        this.status,
        this.totalRecords,
        this.completedRecords,
    });

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        complexName: json["complex_name"],
        status: json["status"],
        totalRecords: json["total_records"],
        completedRecords: json["completed_records"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "complex_name": complexName,
        "status": status,
        "total_records": totalRecords,
        "completed_records": completedRecords,
    };
}

class Record {
    int? id;
    String? maintenanceCode;
    String? title;
    String? headerSubtitle;
    String? category;
    String? workType;
    String? requestedBy;
    String? performedBy;
    String? completedOn;
    String? status;
    String? statusRaw;
    int? cost;
    String? detailsUrl;

    Record({
        this.id,
        this.maintenanceCode,
        this.title,
        this.headerSubtitle,
        this.category,
        this.workType,
        this.requestedBy,
        this.performedBy,
        this.completedOn,
        this.status,
        this.statusRaw,
        this.cost,
        this.detailsUrl,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        maintenanceCode: json["maintenance_code"],
        title: json["title"],
        headerSubtitle: json["header_subtitle"],
        category: json["category"],
        workType: json["work_type"],
        requestedBy: json["requested_by"],
        performedBy: json["performed_by"],
        completedOn: json["completed_on"],
        status: json["status"],
        statusRaw: json["status_raw"],
        cost: json["cost"],
        detailsUrl: json["details_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "maintenance_code": maintenanceCode,
        "title": title,
        "header_subtitle": headerSubtitle,
        "category": category,
        "work_type": workType,
        "requested_by": requestedBy,
        "performed_by": performedBy,
        "completed_on": completedOn,
        "status": status,
        "status_raw": statusRaw,
        "cost": cost,
        "details_url": detailsUrl,
    };
}
