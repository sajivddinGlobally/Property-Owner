// To parse this JSON data, do
//
//     final getServiceRequestModel = getServiceRequestModelFromJson(jsonString);

import 'dart:convert';

GetServiceRequestModel getServiceRequestModelFromJson(String str) => GetServiceRequestModel.fromJson(json.decode(str));

String getServiceRequestModelToJson(GetServiceRequestModel data) => json.encode(data.toJson());

class GetServiceRequestModel {
    bool? status;
    Data? data;

    GetServiceRequestModel({
        this.status,
        this.data,
    });

    factory GetServiceRequestModel.fromJson(Map<String, dynamic> json) => GetServiceRequestModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    SummaryCounts? summaryCounts;
    List<Ticket>? tickets;

    Data({
        this.summaryCounts,
        this.tickets,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        summaryCounts: json["summary_counts"] == null ? null : SummaryCounts.fromJson(json["summary_counts"]),
        tickets: json["tickets"] == null ? [] : List<Ticket>.from(json["tickets"]!.map((x) => Ticket.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "summary_counts": summaryCounts?.toJson(),
        "tickets": tickets == null ? [] : List<dynamic>.from(tickets!.map((x) => x.toJson())),
    };
}

class SummaryCounts {
    String? totalRequests;
    String? inProgress;
    String? completed;
    String? open;

    SummaryCounts({
        this.totalRequests,
        this.inProgress,
        this.completed,
        this.open
    });

    factory SummaryCounts.fromJson(Map<String, dynamic> json) => SummaryCounts(
        totalRequests: json["total_requests"],
        inProgress: json["in_progress"],
        completed: json["completed"],
        open : json["open"]
    );

    Map<String, dynamic> toJson() => {
        "total_requests": totalRequests,
        "in_progress": inProgress,
        "completed": completed,
        "open"  : open
    };
}

class Ticket {
    int? id;
    String? iconType;
    String? title;
    String? ticketNumber;
    String? statusPill;
    String? shortDescription;
    String? category;
    String? priority;
    String? requestedDate;
    String? updatedText;
    String? propertyImage;
    String? propertyNameNumber;
    String? complexName;
 
    Ticket({
        this.id,
        this.iconType,
        this.title,
        this.ticketNumber,
        this.statusPill,
        this.shortDescription,
        this.category,
        this.priority,
        this.requestedDate,
        this.updatedText,
        this.propertyImage,
        this.complexName,
        this.propertyNameNumber,
    });

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        iconType: json["icon_type"],
        title: json["title"],
        ticketNumber: json["ticket_number"],
        statusPill: json["status_pill"],
        shortDescription: json["short_description"],
        category: json["category"],
        priority: json["priority"],
        requestedDate: json["requested_date"],
        updatedText: json["updated_text"],
        propertyImage: json["property_image"],
        complexName: json["complex_name"],
        propertyNameNumber: json["property_name_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "icon_type": iconType,
        "title": title,
        "ticket_number": ticketNumber,
        "status_pill": statusPill,
        "short_description": shortDescription,
        "category": category,
        "priority": priority,
        "requested_date": requestedDate,
        "updated_text": updatedText,
        "property_image": propertyImage,
        "complex_name": complexName,
        "property_name_number": propertyNameNumber,
    };
}
