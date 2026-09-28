import 'dart:convert';

OwnerDashboardModel ownerDashboardModelFromJson(String str) =>
    OwnerDashboardModel.fromJson(json.decode(str));

String ownerDashboardModelToJson(OwnerDashboardModel data) =>
    json.encode(data.toJson());

class OwnerDashboardModel {
  bool? status;
  Data? data;

  OwnerDashboardModel({this.status, this.data});

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardModel(
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Property? property;
  Widgets? widgets;
  int? unreadNotificationsCount;

  Data({this.property, this.widgets, this.unreadNotificationsCount});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      property: json["property"] == null
          ? null
          : Property.fromJson(json["property"]),
      widgets: json["widgets"] == null
          ? null
          : Widgets.fromJson(json["widgets"]),
      unreadNotificationsCount: json["unread_notifications_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "property": property?.toJson(),
    "widgets": widgets?.toJson(),
    "unread_notifications_count": unreadNotificationsCount,
  };
}

class Property {
  int? id;
  String? nameNumber;
  String? type;
  String? location;
  String? area;
  String? status;
  String? imageUrl;
  CarePackage? carePackage;
  double? overallScore;
  double? overallScoreOutOf10;
  bool? isIndependent;
  bool? hasMmc;
  Complex? complex;
  dynamic caretaker;

  Property({
    this.id,
    this.nameNumber,
    this.type,
    this.location,
    this.area,
    this.status,
    this.imageUrl,
    this.carePackage,
    this.overallScore,
    this.overallScoreOutOf10,
    this.isIndependent,
    this.hasMmc,
    this.complex,
    this.caretaker,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json["id"],
      nameNumber: json["name_number"],
      type: json["type"],
      location: json["location"],
      area: json["area"],
      status: json["status"],
      imageUrl: json["image_url"],
      carePackage: json["care_package"] == null
          ? null
          : CarePackage.fromJson(json["care_package"]),
      overallScore: json["overall_score"]?.toDouble(),
      overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
      isIndependent: json["is_independent"],
      hasMmc: json["has_mmc"],
      complex: json["complex"] == null
          ? null
          : Complex.fromJson(json["complex"]),
      caretaker: json["caretaker"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_number": nameNumber,
    "type": type,
    "location": location,
    "area": area,
    "status": status,
    "image_url": imageUrl,
    "care_package": carePackage?.toJson(),
    "overall_score": overallScore,
    "overall_score_out_of_10": overallScoreOutOf10,
    "is_independent": isIndependent,
    "has_mmc": hasMmc,
    "complex": complex?.toJson(),
    "caretaker": caretaker,
  };
}

class CarePackage {
  String? key;
  String? label;

  CarePackage({this.key, this.label});

  factory CarePackage.fromJson(Map<String, dynamic> json) {
    return CarePackage(key: json["key"], label: json["label"]);
  }

  Map<String, dynamic> toJson() => {"key": key, "label": label};
}

class Complex {
  int? id;
  String? name;

  Complex({this.id, this.name});

  factory Complex.fromJson(Map<String, dynamic> json) {
    return Complex(id: json["id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Widgets {
  int? pendingIssues;
  Complaints? serviceRequests;
  Complaints? complaints;
  MaintenancePayment? maintenancePayment;
  int? openMaintenance;
  int? documentsCount;
  LatestInspection? latestInspection;
  LatestAudit? latestAudit;

  int? outstandingAmount;
  int? unreadNotificationsCount;

  Widgets({
    this.pendingIssues,
    this.serviceRequests,
    this.complaints,
    this.maintenancePayment,
    this.openMaintenance,
    this.documentsCount,
    this.latestInspection,
    this.latestAudit,
    this.outstandingAmount,
    this.unreadNotificationsCount,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) {
    return Widgets(
      pendingIssues: json["pending_issues"],

      serviceRequests: json["service_requests"] == null
          ? null
          : Complaints.fromJson(json["service_requests"]),

      complaints: json["complaints"] == null
          ? null
          : Complaints.fromJson(json["complaints"]),

      maintenancePayment: json["maintenance_payment"] == null
          ? null
          : MaintenancePayment.fromJson(json["maintenance_payment"]),

      openMaintenance: json["open_maintenance"],
      documentsCount: json["documents_count"],

      // FIXED
      latestInspection: json["latest_inspection"] == null
          ? null
          : LatestInspection.fromJson(json["latest_inspection"]),

      latestAudit: json["latest_audit"] == null
          ? null
          : LatestAudit.fromJson(json["latest_audit"]),
      outstandingAmount: json["outstanding_amount"],
      unreadNotificationsCount: json["unread_notifications_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "pending_issues": pendingIssues,
    "service_requests": serviceRequests?.toJson(),
    "complaints": complaints?.toJson(),
    "maintenance_payment": maintenancePayment?.toJson(),
    "open_maintenance": openMaintenance,
    "documents_count": documentsCount,
    "latest_inspection": latestInspection?.toJson(),
    "latest_audit": latestAudit?.toJson(),
    "outstanding_amount": outstandingAmount,
    "unread_notifications_count": unreadNotificationsCount,
  };
}

class Complaints {
  int? active;
  int? inProgress;

  Complaints({this.active, this.inProgress});

  factory Complaints.fromJson(Map<String, dynamic> json) {
    return Complaints(active: json["active"], inProgress: json["in_progress"]);
  }

  Map<String, dynamic> toJson() => {
    "active": active,
    "in_progress": inProgress,
  };
}

class LatestInspection {
  int? id;
  DateTime? date;
  double? score;
  String? status;

  LatestInspection({this.id, this.date, this.score, this.status});

  factory LatestInspection.fromJson(Map<String, dynamic> json) {
    return LatestInspection(
      id: json["id"],
      date: json["date"] == null
          ? null
          : DateTime.tryParse(json["date"].toString()),
      score: json["score"]?.toDouble(),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-"
              "${date!.month.toString().padLeft(2, '0')}-"
              "${date!.day.toString().padLeft(2, '0')}",
    "score": score,
    "status": status,
  };
}

class LatestAudit {
  int? id;
  String? title;
  DateTime? createdAt;

  LatestAudit({this.id, this.title, this.createdAt});

  factory LatestAudit.fromJson(Map<String, dynamic> json) {
    return LatestAudit(
      id: json["id"],
      title: json['title'],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt == null
        ? null
        : "${createdAt!.year.toString().padLeft(4, '0')}-"
              "${createdAt!.month.toString().padLeft(2, '0')}-"
              "${createdAt!.day.toString().padLeft(2, '0')}",
  };
}

class MaintenancePayment {
  bool? isApplicable;
  String? status;
  String? reason;
  String? message;
  int? outstanding;
  int? upcoming;
  int? overdue;
  int? remaining;

  MaintenancePayment({
    this.isApplicable,
    this.status,
    this.reason,
    this.message,
    this.outstanding,
    this.upcoming,
    this.overdue,
    this.remaining,
  });

  factory MaintenancePayment.fromJson(Map<String, dynamic> json) {
    return MaintenancePayment(
      isApplicable: json["is_applicable"],
      status: json["status"],
      reason: json["reason"],
      message: json["message"],
      outstanding: json["outstanding"],
      upcoming: json["upcoming"],
      overdue: json["overdue"],
      remaining: json["remaining"],
    );
  }

  Map<String, dynamic> toJson() => {
    "is_applicable": isApplicable,
    "status": status,
    "reason": reason,
    "message": message,
    "outstanding": outstanding,
    "upcoming": upcoming,
    "overdue": overdue,
    "remaining": remaining,
  };
}
