// To parse this JSON data, do
//
//     final consolidatedStatusModel = consolidatedStatusModelFromJson(jsonString);

import 'dart:convert';

ConsolidatedStatusModel consolidatedStatusModelFromJson(String str) => ConsolidatedStatusModel.fromJson(json.decode(str));

String consolidatedStatusModelToJson(ConsolidatedStatusModel data) => json.encode(data.toJson());

class ConsolidatedStatusModel {
    bool? status;
    Data? data;

    ConsolidatedStatusModel({
        this.status,
        this.data,
    });

    factory ConsolidatedStatusModel.fromJson(Map<String, dynamic> json) => ConsolidatedStatusModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    PropertyBanner? propertyBanner;
    CurrentStatus? currentStatus;
    List<MaintenanceActivity>? maintenanceActivities;
    List<ImportantPropertyIssue>? importantPropertyIssues;
    List<LatestReportsDocument>? latestReportsDocuments;

    Data({
        this.propertyBanner,
        this.currentStatus,
        this.maintenanceActivities,
        this.importantPropertyIssues,
        this.latestReportsDocuments,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyBanner: json["property_banner"] == null ? null : PropertyBanner.fromJson(json["property_banner"]),
        currentStatus: json["current_status"] == null ? null : CurrentStatus.fromJson(json["current_status"]),
        maintenanceActivities: json["maintenance_activities"] == null ? [] : List<MaintenanceActivity>.from(json["maintenance_activities"]!.map((x) => MaintenanceActivity.fromJson(x))),
        importantPropertyIssues: json["important_property_issues"] == null ? [] : List<ImportantPropertyIssue>.from(json["important_property_issues"]!.map((x) => ImportantPropertyIssue.fromJson(x))),
        latestReportsDocuments: json["latest_reports_documents"] == null ? [] : List<LatestReportsDocument>.from(json["latest_reports_documents"]!.map((x) => LatestReportsDocument.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "property_banner": propertyBanner?.toJson(),
        "current_status": currentStatus?.toJson(),
        "maintenance_activities": maintenanceActivities == null ? [] : List<dynamic>.from(maintenanceActivities!.map((x) => x.toJson())),
        "important_property_issues": importantPropertyIssues == null ? [] : List<dynamic>.from(importantPropertyIssues!.map((x) => x.toJson())),
        "latest_reports_documents": latestReportsDocuments == null ? [] : List<dynamic>.from(latestReportsDocuments!.map((x) => x.toJson())),
    };
}

class CurrentStatus {
    int? pendingIssues;
    int? openServiceRequests;
    String? recentInspectionDate;
    int? completedWork;

    CurrentStatus({
        this.pendingIssues,
        this.openServiceRequests,
        this.recentInspectionDate,
        this.completedWork,
    });

    factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
        pendingIssues: json["pending_issues"],
        openServiceRequests: json["open_service_requests"],
        recentInspectionDate: json["recent_inspection_date"],
        completedWork: json["completed_work"],
    );

    Map<String, dynamic> toJson() => {
        "pending_issues": pendingIssues,
        "open_service_requests": openServiceRequests,
        "recent_inspection_date": recentInspectionDate,
        "completed_work": completedWork,
    };
}

class ImportantPropertyIssue {
    String? title;
    String? description;
    String? statusLabel;
    String? imageUrl;

    ImportantPropertyIssue({
        this.title,
        this.description,
        this.statusLabel,
        this.imageUrl,
    });

    factory ImportantPropertyIssue.fromJson(Map<String, dynamic> json) => ImportantPropertyIssue(
        title: json["title"],
        description: json["description"],
        statusLabel: json["status_label"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "status_label": statusLabel,
        "image_url": imageUrl,
    };
}

class LatestReportsDocument {
    String? title;
    String? subtitle;

    LatestReportsDocument({
        this.title,
        this.subtitle,
    });

    factory LatestReportsDocument.fromJson(Map<String, dynamic> json) => LatestReportsDocument(
        title: json["title"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
    };
}

class MaintenanceActivity {
    String? title;
    String? description;
    String? timeAgo;

    MaintenanceActivity({
        this.title,
        this.description,
        this.timeAgo,
    });

    factory MaintenanceActivity.fromJson(Map<String, dynamic> json) => MaintenanceActivity(
        title: json["title"],
        description: json["description"],
        timeAgo: json["time_ago"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "time_ago": timeAgo,
    };
}

class PropertyBanner {
    String? propertyName;
    String? complexLocation;
    String? imageUrl;
    String? statusBubble;
    int? score;
    String? statusText;

    PropertyBanner({
        this.propertyName,
        this.complexLocation,
        this.imageUrl,
        this.statusBubble,
        this.score,
        this.statusText,
    });

    factory PropertyBanner.fromJson(Map<String, dynamic> json) => PropertyBanner(
        propertyName: json["property_name"],
        complexLocation: json["complex_location"],
        imageUrl: json["image_url"],
        statusBubble: json["status_bubble"],
        score: json["score"],
        statusText: json["status_text"],
    );

    Map<String, dynamic> toJson() => {
        "property_name": propertyName,
        "complex_location": complexLocation,
        "image_url": imageUrl,
        "status_bubble": statusBubble,
        "score": score,
        "status_text": statusText,
    };
}
