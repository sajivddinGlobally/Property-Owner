// To parse this JSON data, do
//
//     final documentDetailsModel = documentDetailsModelFromJson(jsonString);

import 'dart:convert';

DocumentDetailsModel documentDetailsModelFromJson(String str) => DocumentDetailsModel.fromJson(json.decode(str));

String documentDetailsModelToJson(DocumentDetailsModel data) => json.encode(data.toJson());

class DocumentDetailsModel {
    bool? status;
    Data? data;

    DocumentDetailsModel({
        this.status,
        this.data,
    });

    factory DocumentDetailsModel.fromJson(Map<String, dynamic> json) => DocumentDetailsModel(
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
    PropertyOverview? propertyOverview;
    String? description;
    ActionUrls? actionUrls;

    Data({
        this.header,
        this.propertyOverview,
        this.description,
        this.actionUrls,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        propertyOverview: json["property_overview"] == null ? null : PropertyOverview.fromJson(json["property_overview"]),
        description: json["description"],
        actionUrls: json["action_urls"] == null ? null : ActionUrls.fromJson(json["action_urls"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "property_overview": propertyOverview?.toJson(),
        "description": description,
        "action_urls": actionUrls?.toJson(),
    };
}

class ActionUrls {
    String? downloadUrl;
    String? shareUrl;

    ActionUrls({
        this.downloadUrl,
        this.shareUrl,
    });

    factory ActionUrls.fromJson(Map<String, dynamic> json) => ActionUrls(
        downloadUrl: json["download_url"],
        shareUrl: json["share_url"],
    );

    Map<String, dynamic> toJson() => {
        "download_url": downloadUrl,
        "share_url": shareUrl,
    };
}

class Header {
    String? documentPreviewUrl;

    Header({
        this.documentPreviewUrl,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        documentPreviewUrl: json["document_preview_url"],
    );

    Map<String, dynamic> toJson() => {
        "document_preview_url": documentPreviewUrl,
    };
}

class PropertyOverview {
    String? documentName;
    String? category;
    String? fileType;
    String? fileSize;
    String? uploadedOn;
    String? documentStatus;

    PropertyOverview({
        this.documentName,
        this.category,
        this.fileType,
        this.fileSize,
        this.uploadedOn,
        this.documentStatus,
    });

    factory PropertyOverview.fromJson(Map<String, dynamic> json) => PropertyOverview(
        documentName: json["document_name"],
        category: json["category"],
        fileType: json["file_type"],
        fileSize: json["file_size"],
        uploadedOn: json["uploaded_on"],
        documentStatus: json["document_status"],
    );

    Map<String, dynamic> toJson() => {
        "document_name": documentName,
        "category": category,
        "file_type": fileType,
        "file_size": fileSize,
        "uploaded_on": uploadedOn,
        "document_status": documentStatus,
    };
}
