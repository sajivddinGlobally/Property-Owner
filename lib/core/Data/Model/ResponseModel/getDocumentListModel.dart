// To parse this JSON data, do
//
//     final getDocumentListModel = getDocumentListModelFromJson(jsonString);

import 'dart:convert';

GetDocumentListModel getDocumentListModelFromJson(String str) => GetDocumentListModel.fromJson(json.decode(str));

String getDocumentListModelToJson(GetDocumentListModel data) => json.encode(data.toJson());

class GetDocumentListModel {
    bool? status;
    Data? data;

    GetDocumentListModel({
        this.status,
        this.data,
    });

    factory GetDocumentListModel.fromJson(Map<String, dynamic> json) => GetDocumentListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    PropertyOverview? propertyOverview;
    StorageUsage? storageUsage;
    List<RecentDocument>? recentDocuments;

    Data({
        this.propertyOverview,
        this.storageUsage,
        this.recentDocuments,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyOverview: json["property_overview"] == null ? null : PropertyOverview.fromJson(json["property_overview"]),
        storageUsage: json["storage_usage"] == null ? null : StorageUsage.fromJson(json["storage_usage"]),
        recentDocuments: json["recent_documents"] == null ? [] : List<RecentDocument>.from(json["recent_documents"]!.map((x) => RecentDocument.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "property_overview": propertyOverview?.toJson(),
        "storage_usage": storageUsage?.toJson(),
        "recent_documents": recentDocuments == null ? [] : List<dynamic>.from(recentDocuments!.map((x) => x.toJson())),
    };
}

class PropertyOverview {
    String? propertyName;
    String? propertyNumber;
    String? complexLocation;
    String? imageUrl;
    String? totalDocumentsCount;

    PropertyOverview({
        this.propertyName,
        this.propertyNumber,
        this.complexLocation,
        this.imageUrl,
        this.totalDocumentsCount,
    });

    factory PropertyOverview.fromJson(Map<String, dynamic> json) => PropertyOverview(
        propertyName: json["property_name"],
        propertyNumber: json["property_number"],
        complexLocation: json["complex_location"],
        imageUrl: json["image_url"],
        totalDocumentsCount: json["total_documents_count"],
    );

    Map<String, dynamic> toJson() => {
        "property_name": propertyName,
        "property_number": propertyNumber,
        "complex_location": complexLocation,
        "image_url": imageUrl,
        "total_documents_count": totalDocumentsCount,
    };
}

class RecentDocument {
    int? id;
    String? title;
    String? categoryPill;
    String? fileTypeSize;

    RecentDocument({
        this.id,
        this.title,
        this.categoryPill,
        this.fileTypeSize,
    });

    factory RecentDocument.fromJson(Map<String, dynamic> json) => RecentDocument(
        id: json["id"],
        title: json["title"],
        categoryPill: json["category_pill"],
        fileTypeSize: json["file_type_size"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_pill": categoryPill,
        "file_type_size": fileTypeSize,
    };
}

class StorageUsage {
    double? usedMb;
    int? totalMb;
    String? usageText;

    StorageUsage({
        this.usedMb,
        this.totalMb,
        this.usageText,
    });

    factory StorageUsage.fromJson(Map<String, dynamic> json) => StorageUsage(
        usedMb: json["used_mb"]?.toDouble(),
        totalMb: json["total_mb"],
        usageText: json["usage_text"],
    );

    Map<String, dynamic> toJson() => {
        "used_mb": usedMb,
        "total_mb": totalMb,
        "usage_text": usageText,
    };
}
