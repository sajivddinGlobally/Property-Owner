// To parse this JSON data, do
//
//     final getServiceRequestDetailsModel = getServiceRequestDetailsModelFromJson(jsonString);

import 'dart:convert';

GetServiceRequestDetailsModel getServiceRequestDetailsModelFromJson(
  String str,
) => GetServiceRequestDetailsModel.fromJson(json.decode(str));

String getServiceRequestDetailsModelToJson(
  GetServiceRequestDetailsModel data,
) => json.encode(data.toJson());

class GetServiceRequestDetailsModel {
  bool? status;
  Data? data;

  GetServiceRequestDetailsModel({this.status, this.data});

  factory GetServiceRequestDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetServiceRequestDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Header? header;
  RequestInformation? requestInformation;
  String? requestDetails;
  List<StatusTimeline>? statusTimeline;
  AssignedTo? assignedTo;
  List<Attachment>? attachments;

  Data({
    this.header,
    this.requestInformation,
    this.requestDetails,
    this.statusTimeline,
    this.assignedTo,
    this.attachments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(_asMap(json["header"])),
    requestInformation: json["request_information"] == null
        ? null
        : RequestInformation.fromJson(_asMap(json["request_information"])),
    requestDetails: json["request_details"]?.toString() ?? json["description"]?.toString(),
    statusTimeline: _parseStatusTimeline(json["status_timeline"]),
    assignedTo: json["assigned_to"] == null
        ? null
        : AssignedTo.fromJson(_asMap(json["assigned_to"])),
    attachments: _parseAttachments(json["attachments"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "request_information": requestInformation?.toJson(),
    "request_details": requestDetails,
    "status_timeline": statusTimeline == null
        ? []
        : List<dynamic>.from(statusTimeline!.map((x) => x.toJson())),
    "assigned_to": assignedTo?.toJson(),
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x.toJson())),
  };
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

List<Attachment> _parseAttachments(dynamic raw) {
  if (raw == null) return [];
  if (raw is List) {
    return raw.map((x) {
      if (x is Map<String, dynamic>) {
        return Attachment.fromJson(x);
      } else if (x is Map) {
        return Attachment.fromJson(Map<String, dynamic>.from(x));
      } else if (x is String) {
        return Attachment(url: x, fileName: x.split('/').last);
      }
      return Attachment();
    }).toList();
  }
  if (raw is Map) {
    if (raw.containsKey("url") ||
        raw.containsKey("file_name") ||
        raw.containsKey("file_url") ||
        raw.containsKey("attachment_url")) {
      return [Attachment.fromJson(Map<String, dynamic>.from(raw))];
    }
    return raw.values.map((x) {
      if (x is Map<String, dynamic>) {
        return Attachment.fromJson(x);
      } else if (x is Map) {
        return Attachment.fromJson(Map<String, dynamic>.from(x));
      } else if (x is String) {
        return Attachment(url: x, fileName: x.split('/').last);
      }
      return Attachment();
    }).toList();
  }
  if (raw is String && raw.trim().isNotEmpty) {
    return [Attachment(url: raw, fileName: raw.split('/').last)];
  }
  return [];
}

List<StatusTimeline> _parseStatusTimeline(dynamic raw) {
  if (raw == null) return [];
  if (raw is List) {
    return raw.map((x) {
      if (x is Map<String, dynamic>) {
        return StatusTimeline.fromJson(x);
      } else if (x is Map) {
        return StatusTimeline.fromJson(Map<String, dynamic>.from(x));
      }
      return StatusTimeline();
    }).toList();
  }
  if (raw is Map) {
    return raw.values.map((x) {
      if (x is Map<String, dynamic>) {
        return StatusTimeline.fromJson(x);
      } else if (x is Map) {
        return StatusTimeline.fromJson(Map<String, dynamic>.from(x));
      }
      return StatusTimeline();
    }).toList();
  }
  return [];
}

class Attachment {
  String? fileName;
  String? type;
  String? size;
  String? url;

  Attachment({this.fileName, this.type, this.size, this.url});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    fileName: (json["file_name"] ?? json["fileName"] ?? json["name"] ?? json["title"])?.toString(),
    type: (json["type"] ?? json["file_type"] ?? json["mime_type"])?.toString(),
    size: json["size"]?.toString() ?? json["file_size"]?.toString(),
    url: (json["url"] ?? json["file_url"] ?? json["path"] ?? json["attachment_url"] ?? json["photo"])?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "file_name": fileName,
    "type": type,
    "size": size,
    "url": url,
  };
}

class Header {
  String? ticketNumber;
  String? title;
  String? subtitle;
  String? submitted;
  String? statusPill;
  int? completionPercentage;

  Header({
    this.ticketNumber,
    this.title,
    this.subtitle,
    this.submitted,
    this.statusPill,
    this.completionPercentage,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    ticketNumber: (json["ticket_number"] ?? json["ticketNumber"] ?? json["token_number"] ?? json["id"])?.toString(),
    title: json["title"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
    submitted: (json["Submitted"] ?? json["submitted"] ?? json["created_at"])?.toString(),
    statusPill: (json["status_pill"] ?? json["status"] ?? json["statusPill"])?.toString(),
    completionPercentage: json["completion_percentage"] is int
        ? json["completion_percentage"]
        : (json["completion_percentage"] != null
            ? int.tryParse(json["completion_percentage"].toString()) ??
                (double.tryParse(json["completion_percentage"].toString())?.toInt())
            : null),
  );

  Map<String, dynamic> toJson() => {
    "ticket_number": ticketNumber,
    "title": title,
    "subtitle": subtitle,
    "status_pill": statusPill,
    "Submitted": submitted,
    "completion_percentage": completionPercentage,
  };
}

class RequestInformation {
  String? serviceCategory;
  String? serviceType;
  String? priority;
  String? preferredDate;
  String? property;

  RequestInformation({
    this.serviceCategory,
    this.serviceType,
    this.priority,
    this.preferredDate,
    this.property,
  });

  factory RequestInformation.fromJson(Map<String, dynamic> json) =>
      RequestInformation(
        serviceCategory: (json["service_category"] ?? json["category"])?.toString(),
        serviceType: (json["service_type"] ?? json["type"])?.toString(),
        priority: json["priority"]?.toString(),
        preferredDate: (json["preferred_date"] ?? json["date"])?.toString(),
        property: json["property"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "service_category": serviceCategory,
    "service_type": serviceType,
    "priority": priority,
    "preferred_date": preferredDate,
    "property": property,
  };
}

class StatusTimeline {
  String? statusKey;
  String? label;
  String? dateTime;
  bool? isCompleted;
  bool? isCurrent;

  StatusTimeline({
    this.statusKey,
    this.label,
    this.dateTime,
    this.isCompleted,
    this.isCurrent,
  });

  factory StatusTimeline.fromJson(Map<String, dynamic> json) => StatusTimeline(
    statusKey: (json["status_key"] ?? json["status"])?.toString(),
    label: (json["label"] ?? json["title"] ?? json["name"])?.toString(),
    dateTime: (json["date_time"] ?? json["date"] ?? json["created_at"])?.toString(),
    isCompleted: json["is_completed"] == true ||
        json["is_completed"] == 1 ||
        json["is_completed"] == "1" ||
        json["is_completed"] == "true",
    isCurrent: json["is_current"] == true ||
        json["is_current"] == 1 ||
        json["is_current"] == "1" ||
        json["is_current"] == "true",
  );

  Map<String, dynamic> toJson() => {
    "status_key": statusKey,
    "label": label,
    "date_time": dateTime,
    "is_completed": isCompleted,
    "is_current": isCurrent,
  };
}

class AssignedTo {
  String? name;
  String? role;
  String? avatarUrl;
  String? phone;

  AssignedTo({this.name, this.role, this.avatarUrl, this.phone});

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
    name: json["name"]?.toString(),
    role: json["role"]?.toString(),
    avatarUrl: (json["avatar_url"] ?? json["avatar"] ?? json["image"])?.toString(),
    phone: (json["phone"] ?? json["contact"] ?? json["mobile"])?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "avatar_url": avatarUrl,
    "phone": phone,
  };
}
