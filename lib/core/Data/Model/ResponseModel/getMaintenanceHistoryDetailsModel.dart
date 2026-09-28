// To parse this JSON data, do
//
//     final getMaintenanceHistoryDetailsModel = getMaintenanceHistoryDetailsModelFromJson(jsonString);

import 'dart:convert';

GetMaintenanceHistoryDetailsModel getMaintenanceHistoryDetailsModelFromJson(String str) => GetMaintenanceHistoryDetailsModel.fromJson(json.decode(str));

String getMaintenanceHistoryDetailsModelToJson(GetMaintenanceHistoryDetailsModel data) => json.encode(data.toJson());

class GetMaintenanceHistoryDetailsModel {
    bool? status;
    Data? data;

    GetMaintenanceHistoryDetailsModel({
        this.status,
        this.data,
    });

    factory GetMaintenanceHistoryDetailsModel.fromJson(Map<String, dynamic> json) => GetMaintenanceHistoryDetailsModel(
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
    Information? information;
    WorkDetails? workDetails;
    List<Timeline>? timeline;
    AssignedTeam? assignedTeam;
    List<RelatedDocument>? relatedDocuments;
    String? notes;

    Data({
        this.header,
        this.information,
        this.workDetails,
        this.timeline,
        this.assignedTeam,
        this.relatedDocuments,
        this.notes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        information: json["information"] == null ? null : Information.fromJson(json["information"]),
        workDetails: json["work_details"] == null ? null : WorkDetails.fromJson(json["work_details"]),
        timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
        assignedTeam: json["assigned_team"] == null ? null : AssignedTeam.fromJson(json["assigned_team"]),
        relatedDocuments: json["related_documents"] == null ? [] : List<RelatedDocument>.from(json["related_documents"]!.map((x) => RelatedDocument.fromJson(x))),
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "information": information?.toJson(),
        "work_details": workDetails?.toJson(),
        "timeline": timeline == null ? [] : List<dynamic>.from(timeline!.map((x) => x.toJson())),
        "assigned_team": assignedTeam?.toJson(),
        "related_documents": relatedDocuments == null ? [] : List<dynamic>.from(relatedDocuments!.map((x) => x.toJson())),
        "notes": notes,
    };
}

class AssignedTeam {
    String? name;
    String? role;
    String? status;
    String? avatar;

    AssignedTeam({
        this.name,
        this.role,
        this.status,
        this.avatar,
    });

    factory AssignedTeam.fromJson(Map<String, dynamic> json) => AssignedTeam(
        name: json["name"],
        role: json["role"],
        status: json["status"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "status": status,
        "avatar": avatar,
    };
}

class Header {
    String? maintenanceCode;
    String? title;
    String? workType;
    String? status;

    Header({
        this.maintenanceCode,
        this.title,
        this.workType,
        this.status,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        maintenanceCode: json["maintenance_code"],
        title: json["title"],
        workType: json["work_type"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "maintenance_code": maintenanceCode,
        "title": title,
        "work_type": workType,
        "status": status,
    };
}

class Information {
    String? property;
    String? complex;
    String? category;
    String? workType;
    String? requestDate;
    String? completedDate;
    String? currentStatus;

    Information({
        this.property,
        this.complex,
        this.category,
        this.workType,
        this.requestDate,
        this.completedDate,
        this.currentStatus,
    });

    factory Information.fromJson(Map<String, dynamic> json) => Information(
        property: json["property"],
        complex: json["complex"],
        category: json["category"],
        workType: json["work_type"],
        requestDate: json["request_date"],
        completedDate: json["completed_date"],
        currentStatus: json["current_status"],
    );

    Map<String, dynamic> toJson() => {
        "property": property,
        "complex": complex,
        "category": category,
        "work_type": workType,
        "request_date": requestDate,
        "completed_date": completedDate,
        "current_status": currentStatus,
    };
}

class RelatedDocument {
    String? fileName;
    String? title;
    String? fileSize;
    String? fileType;
    String? downloadUrl;

    RelatedDocument({
        this.fileName,
        this.title,
        this.fileSize,
        this.fileType,
        this.downloadUrl,
    });

    factory RelatedDocument.fromJson(Map<String, dynamic> json) => RelatedDocument(
        fileName: json["file_name"],
        title: json["title"],
        fileSize: json["file_size"],
        fileType: json["file_type"],
        downloadUrl: json["download_url"],
    );

    Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "title": title,
        "file_size": fileSize,
        "file_type": fileType,
        "download_url": downloadUrl,
    };
}

class Timeline {
    int? step;
    String? title;
    String? timestamp;
    String? status;

    Timeline({
        this.step,
        this.title,
        this.timestamp,
        this.status,
    });

    factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        step: json["step"],
        title: json["title"],
        timestamp: json["timestamp"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "step": step,
        "title": title,
        "timestamp": timestamp,
        "status": status,
    };
}

class WorkDetails {
    String? description;

    WorkDetails({
        this.description,
    });

    factory WorkDetails.fromJson(Map<String, dynamic> json) => WorkDetails(
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
    };
}
