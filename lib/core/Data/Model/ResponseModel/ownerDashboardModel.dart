// // // To parse this JSON data, do
// // //
// // //     final ownerDashboardModel = ownerDashboardModelFromJson(jsonString);

// // import 'dart:convert';

// // OwnerDashboardModel ownerDashboardModelFromJson(String str) =>
// //     OwnerDashboardModel.fromJson(json.decode(str));

// // String ownerDashboardModelToJson(OwnerDashboardModel data) =>
// //     json.encode(data.toJson());

// // class OwnerDashboardModel {
// //   bool? status;
// //   Data? data;

// //   OwnerDashboardModel({this.status, this.data});

// //   factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
// //       OwnerDashboardModel(
// //         status: json["status"],
// //         data: json["data"] == null ? null : Data.fromJson(json["data"]),
// //       );

// //   Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
// // }

// // class Data {
// //   bool? isApproved;
// //   String? approvalStatus;
// //   bool? activeDashboard;
// //   Property? property;
// //   Widgets? widgets;
// //   Notice? notice;
// //   int? unreadNotificationsCount;

// //   Data({
// //     this.isApproved,
// //     this.approvalStatus,
// //     this.activeDashboard,
// //     this.property,
// //     this.widgets,
// //     this.unreadNotificationsCount,
// //   });

// //   factory Data.fromJson(Map<String, dynamic> json) => Data(
// //     isApproved: json["is_approved"],
// //     approvalStatus: json["approval_status"],
// //     activeDashboard: json["active_dashboard"],
// //     property: json["property"] == null
// //         ? null
// //         : Property.fromJson(json["property"]),
// //     widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
// //     unreadNotificationsCount: json["unread_notifications_count"],
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "is_approved": isApproved,
// //     "approval_status": approvalStatus,
// //     "active_dashboard": activeDashboard,
// //     "property": property?.toJson(),
// //     "widgets": widgets?.toJson(),
// //     "unread_notifications_count": unreadNotificationsCount,
// //   };
// // }

// // class Property {
// //   int? id;
// //   String? nameNumber;
// //   String? type;
// //   String? location;
// //   String? area;
// //   String? bedrooms;
// //   String? floors;
// //   String? occupancyStatus;
// //   String? status;
// //   String? statusLabel;
// //   String? imageUrl;
// //   CarePackage? carePackage;
// //   double? overallScore;
// //   double? overallScoreOutOf10;
// //   String? scoreDisplay;
// //   String? scoreStatus;
// //   bool? isIndependent;
// //   bool? hasMmc;
// //   dynamic complex;
// //   Caretaker? caretaker;

// //   String? get complexName {
// //     if (complex == null) return null;
// //     if (complex is Map) {
// //       return (complex['name'] ?? complex['complex_name'])?.toString();
// //     }
// //     if (complex is String) return complex;
// //     try {
// //       return (complex as dynamic).name?.toString();
// //     } catch (_) {
// //       return null;
// //     }
// //   }

// //   Property({
// //     this.id,
// //     this.nameNumber,
// //     this.type,
// //     this.location,
// //     this.area,
// //     this.bedrooms,
// //     this.floors,
// //     this.occupancyStatus,
// //     this.status,
// //     this.statusLabel,
// //     this.imageUrl,
// //     this.carePackage,
// //     this.overallScore,
// //     this.overallScoreOutOf10,
// //     this.scoreDisplay,
// //     this.scoreStatus,
// //     this.isIndependent,
// //     this.hasMmc,
// //     this.complex,
// //     this.caretaker,
// //   });

// //   factory Property.fromJson(Map<String, dynamic> json) => Property(
// //     id: json["id"],
// //     nameNumber: json["name_number"],
// //     type: json["type"],
// //     location: json["location"],
// //     area: json["area"],
// //     bedrooms: json["bedrooms"],
// //     floors: json["floors"],
// //     occupancyStatus: json["occupancy_status"],
// //     status: json["status"],
// //     statusLabel: json["status_label"],
// //     imageUrl: json["image_url"],
// //     carePackage: json["care_package"] == null
// //         ? null
// //         : CarePackage.fromJson(json["care_package"]),
// //     overallScore: json["overall_score"]?.toDouble(),
// //     overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
// //     scoreDisplay: json["score_display"],
// //     scoreStatus: json["score_status"],
// //     isIndependent: json["is_independent"],
// //     hasMmc: json["has_mmc"],
// //     complex: json["complex"],
// //     caretaker: json["caretaker"] == null
// //         ? null
// //         : Caretaker.fromJson(json["caretaker"]),
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "name_number": nameNumber,
// //     "type": type,
// //     "location": location,
// //     "area": area,
// //     "bedrooms": bedrooms,
// //     "floors": floors,
// //     "occupancy_status": occupancyStatus,
// //     "status": status,
// //     "status_label": statusLabel,
// //     "image_url": imageUrl,
// //     "care_package": carePackage?.toJson(),
// //     "overall_score": overallScore,
// //     "overall_score_out_of_10": overallScoreOutOf10,
// //     "score_display": scoreDisplay,
// //     "score_status": scoreStatus,
// //     "is_independent": isIndependent,
// //     "has_mmc": hasMmc,
// //     "complex": complex,
// //     "caretaker": caretaker?.toJson(),
// //   };
// // }

// // class CarePackage {
// //   String? key;
// //   String? label;

// //   CarePackage({this.key, this.label});

// //   factory CarePackage.fromJson(Map<String, dynamic> json) =>
// //       CarePackage(key: json["key"], label: json["label"]);

// //   Map<String, dynamic> toJson() => {"key": key, "label": label};
// // }

// // class Caretaker {
// //   int? id;
// //   String? name;
// //   String? phone;

// //   Caretaker({this.id, this.name, this.phone});

// //   factory Caretaker.fromJson(Map<String, dynamic> json) =>
// //       Caretaker(id: json["id"], name: json["name"], phone: json["phone"]);

// //   Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
// // }

// // class Widgets {
// //   int? pendingIssues;
// //   Complaints? serviceRequests;
// //   Complaints? complaints;
// //   MaintenancePayment? maintenancePayment;
// //   int? openMaintenance;
// //   int? documentsCount;
// //   LatestInspection? latestInspection;
// //   LatestAudit? latestAudit;
// //   LatestAuditReport? latestAuditReport;
// //   int? outstandingAmount;
// //   int? unreadNotificationsCount;

// //   Widgets({
// //     this.pendingIssues,
// //     this.serviceRequests,
// //     this.complaints,
// //     this.maintenancePayment,
// //     this.openMaintenance,
// //     this.documentsCount,
// //     this.latestInspection,
// //     this.latestAudit,
// //     this.latestAuditReport,
// //     this.outstandingAmount,
// //     this.unreadNotificationsCount,
// //   });

// //   factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
// //     pendingIssues: json["pending_issues"],
// //     serviceRequests: json["service_requests"] == null
// //         ? null
// //         : Complaints.fromJson(json["service_requests"]),
// //     complaints: json["complaints"] == null
// //         ? null
// //         : Complaints.fromJson(json["complaints"]),
// //     maintenancePayment: json["maintenance_payment"] == null
// //         ? null
// //         : MaintenancePayment.fromJson(json["maintenance_payment"]),
// //     openMaintenance: json["open_maintenance"],
// //     documentsCount: json["documents_count"],
// //     latestInspection: json["latest_inspection"] == null
// //         ? null
// //         : LatestInspection.fromJson(json["latest_inspection"]),
// //     latestAudit: json["latest_audit"] == null
// //         ? null
// //         : LatestAudit.fromJson(json["latest_audit"]),
// //     latestAuditReport: json["latest_audit_report"] == null
// //         ? null
// //         : LatestAuditReport.fromJson(json["latest_audit_report"]),
// //     outstandingAmount: json["outstanding_amount"],
// //     unreadNotificationsCount: json["unread_notifications_count"],
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "pending_issues": pendingIssues,
// //     "service_requests": serviceRequests?.toJson(),
// //     "complaints": complaints?.toJson(),
// //     "maintenance_payment": maintenancePayment?.toJson(),
// //     "open_maintenance": openMaintenance,
// //     "documents_count": documentsCount,
// //     "latest_inspection": latestInspection?.toJson(),
// //     "latest_audit": latestAudit?.toJson(),
// //     "latest_audit_report": latestAuditReport?.toJson(),
// //     "outstanding_amount": outstandingAmount,
// //     "unread_notifications_count": unreadNotificationsCount,
// //   };
// // }

// // class Complaints {
// //   int? active;
// //   int? total;
// //   int? pending;
// //   int? inProgress;

// //   Complaints({this.active, this.inProgress, this.total, this.pending});

// //   factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
// //     active: json["active"],
// //     inProgress: json["in_progress"],
// //     total: json["total"],
// //     pending: json["pending"],
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "active": active,
// //     "in_progress": inProgress,
// //     "total": total,
// //     "pending": pending,
// //   };
// // }

// // class LatestInspection {
// //   int? id;
// //   DateTime? date;
// //   DateTime? inspectionDate;
// //   String? dateFormatted;
// //   String? inspectionDateFormatted;
// //   double? score;
// //   String? status;
// //   String? reportType;

// //   LatestInspection({
// //     this.id,
// //     this.date,
// //     this.inspectionDate,
// //     this.dateFormatted,
// //     this.inspectionDateFormatted,
// //     this.score,
// //     this.status,
// //     this.reportType,
// //   });

// //   factory LatestInspection.fromJson(Map<String, dynamic> json) =>
// //       LatestInspection(
// //         id: json["id"],
// //         date: json["date"] == null ? null : DateTime.parse(json["date"]),
// //         inspectionDate: json["inspection_date"] == null
// //             ? null
// //             : DateTime.parse(json["inspection_date"]),
// //         dateFormatted: json["date_formatted"],
// //         inspectionDateFormatted: json["inspection_date_formatted"],
// //         score: json["score"]?.toDouble(),
// //         status: json["status"],
// //         reportType: json["report_type"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "date": date == null
// //         ? null
// //         : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
// //     "inspection_date": inspectionDate == null
// //         ? null
// //         : "${inspectionDate!.year.toString().padLeft(4, '0')}-${inspectionDate!.month.toString().padLeft(2, '0')}-${inspectionDate!.day.toString().padLeft(2, '0')}",
// //     "date_formatted": dateFormatted,
// //     "inspection_date_formatted": inspectionDateFormatted,
// //     "score": score,
// //     "status": status,
// //     "report_type": reportType,
// //   };
// // }

// // class LatestAudit {
// //   int? id;
// //   String? title;
// //   DateTime? createdAt;

// //   LatestAudit({this.id, this.title, this.createdAt});

// //   factory LatestAudit.fromJson(Map<String, dynamic> json) => LatestAudit(
// //     id: json["id"],
// //     title: json["title"],
// //     createdAt: json["created_at"] == null
// //         ? null
// //         : DateTime.parse(json["created_at"]),
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "title": title,
// //     "created_at": createdAt?.toIso8601String(),
// //   };
// // }

// // class LatestAuditReport {
// //   int? id;
// //   String? auditType;
// //   DateTime? date;
// //   String? dateFormatted;
// //   num? score;
// //   String? scoreLabel;
// //   String? tier;
// //   int? totalCheckpoints;
// //   int? passed;
// //   int? needsAttention;
// //   String? checklistPdfUrl;

// //   LatestAuditReport({
// //     this.id,
// //     this.auditType,
// //     this.date,
// //     this.dateFormatted,
// //     this.score,
// //     this.scoreLabel,
// //     this.tier,
// //     this.totalCheckpoints,
// //     this.passed,
// //     this.needsAttention,
// //     this.checklistPdfUrl,
// //   });

// //   factory LatestAuditReport.fromJson(Map<String, dynamic> json) =>
// //       LatestAuditReport(
// //         id: json["id"] is int
// //             ? json["id"]
// //             : int.tryParse(json["id"]?.toString() ?? ""),
// //         auditType: json["audit_type"],
// //         date: json["date"] == null
// //             ? null
// //             : DateTime.tryParse(json["date"].toString()),
// //         dateFormatted: json["date_formatted"],
// //         score: json["score"] is num
// //             ? json["score"]
// //             : num.tryParse(json["score"]?.toString() ?? ""),
// //         scoreLabel: json["score_label"],
// //         tier: json["tier"],
// //         totalCheckpoints: json["total_checkpoints"] is int
// //             ? json["total_checkpoints"]
// //             : int.tryParse(json["total_checkpoints"]?.toString() ?? ""),
// //         passed: json["passed"] is int
// //             ? json["passed"]
// //             : int.tryParse(json["passed"]?.toString() ?? ""),
// //         needsAttention: json["needs_attention"] is int
// //             ? json["needs_attention"]
// //             : int.tryParse(json["needs_attention"]?.toString() ?? ""),
// //         checklistPdfUrl: json["checklist_pdf_url"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "audit_type": auditType,
// //     "date": date?.toIso8601String().split('T').first,
// //     "date_formatted": dateFormatted,
// //     "score": score,
// //     "score_label": scoreLabel,
// //     "tier": tier,
// //     "total_checkpoints": totalCheckpoints,
// //     "passed": passed,
// //     "needs_attention": needsAttention,
// //     "checklist_pdf_url": checklistPdfUrl,
// //   };
// // }

// // class MaintenancePayment {
// //   bool? isApplicable;
// //   String? status;
// //   String? reason;
// //   String? message;
// //   int? outstanding;
// //   int? upcoming;
// //   int? overdue;
// //   int? remaining;

// //   MaintenancePayment({
// //     this.isApplicable,
// //     this.status,
// //     this.reason,
// //     this.message,
// //     this.outstanding,
// //     this.upcoming,
// //     this.overdue,
// //     this.remaining,
// //   });

// //   factory MaintenancePayment.fromJson(Map<String, dynamic> json) =>
// //       MaintenancePayment(
// //         isApplicable: json["is_applicable"],
// //         status: json["status"],
// //         reason: json["reason"],
// //         message: json["message"],
// //         outstanding: json["outstanding"],
// //         upcoming: json["upcoming"],
// //         overdue: json["overdue"],
// //         remaining: json["remaining"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //     "is_applicable": isApplicable,
// //     "status": status,
// //     "reason": reason,
// //     "message": message,
// //     "outstanding": outstanding,
// //     "upcoming": upcoming,
// //     "overdue": overdue,
// //     "remaining": remaining,
// //   };
// // }

// // class Notice {
// //   String? title;
// //   String? description;
// //   String? badge;

// //   Notice({this.title, this.description, this.badge});

// //   factory Notice.fromJson(Map<String, dynamic> json) => Notice(
// //     title: json["title"],
// //     description: json["description"],
// //     badge: json["badge"],
// //   );

// //   Map<String, dynamic> toJson() => {
// //     "title": title,
// //     "description": description,
// //     "badge": badge,
// //   };
// // }

// // To parse this JSON data, do
// //
// //     final ownerDashboardModel = ownerDashboardModelFromJson(jsonString);

// import 'dart:convert';

// OwnerDashboardModel ownerDashboardModelFromJson(String str) =>
//     OwnerDashboardModel.fromJson(json.decode(str));

// String ownerDashboardModelToJson(OwnerDashboardModel data) =>
//     json.encode(data.toJson());

// class OwnerDashboardModel {
//   bool? status;
//   Data? data;

//   OwnerDashboardModel({this.status, this.data});

//   factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
//       OwnerDashboardModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
// }

// class Data {
//   bool? isApproved;
//   String? approvalStatus;
//   bool? activeDashboard;
//   Property? property;
//   Widgets? widgets;
//   Notice? notice;
//   int? unreadNotificationsCount;

//   Data({
//     this.isApproved,
//     this.approvalStatus,
//     this.activeDashboard,
//     this.property,
//     this.widgets,
//     this.unreadNotificationsCount,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     isApproved: json["is_approved"],
//     approvalStatus: json["approval_status"],
//     activeDashboard: json["active_dashboard"],
//     property: json["property"] == null
//         ? null
//         : Property.fromJson(json["property"]),
//     widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
//     unreadNotificationsCount: json["unread_notifications_count"],
//   );

//   Map<String, dynamic> toJson() => {
//     "is_approved": isApproved,
//     "approval_status": approvalStatus,
//     "active_dashboard": activeDashboard,
//     "property": property?.toJson(),
//     "widgets": widgets?.toJson(),
//     "unread_notifications_count": unreadNotificationsCount,
//   };
// }

// class Property {
//   int? id;
//   String? nameNumber;
//   String? type;
//   String? location;
//   String? area;
//   String? bedrooms;
//   String? floors;
//   String? occupancyStatus;
//   String? status;
//   String? statusLabel;
//   String? imageUrl;
//   CarePackage? carePackage;
//   double? overallScore;
//   double? overallScoreOutOf10;
//   String? scoreDisplay;
//   String? scoreStatus;
//   bool? isIndependent;
//   bool? hasMmc;
//   dynamic complex;
//   // Owner side Apartment / Villa: complex sirf naam (backend "complex_name")
//   String? complexNameText;
//   Caretaker? caretaker;

//   String? get complexName {
//     if (complex == null) {
//       final t = complexNameText;
//       return (t != null && t.trim().isNotEmpty) ? t : null;
//     }
//     if (complex is Map) {
//       return (complex['name'] ?? complex['complex_name'])?.toString();
//     }
//     if (complex is String) return complex;
//     try {
//       return (complex as dynamic).name?.toString();
//     } catch (_) {
//       return null;
//     }
//   }

//   Property({
//     this.id,
//     this.nameNumber,
//     this.type,
//     this.location,
//     this.area,
//     this.bedrooms,
//     this.floors,
//     this.occupancyStatus,
//     this.status,
//     this.statusLabel,
//     this.imageUrl,
//     this.carePackage,
//     this.overallScore,
//     this.overallScoreOutOf10,
//     this.scoreDisplay,
//     this.scoreStatus,
//     this.isIndependent,
//     this.hasMmc,
//     this.complex,
//     this.complexNameText,
//     this.caretaker,
//   });

//   factory Property.fromJson(Map<String, dynamic> json) => Property(
//     id: json["id"],
//     nameNumber: json["name_number"],
//     type: json["type"],
//     location: json["location"],
//     area: json["area"],
//     bedrooms: json["bedrooms"],
//     floors: json["floors"],
//     occupancyStatus: json["occupancy_status"],
//     status: json["status"],
//     statusLabel: json["status_label"],
//     imageUrl: json["image_url"],
//     carePackage: json["care_package"] == null
//         ? null
//         : CarePackage.fromJson(json["care_package"]),
//     overallScore: json["overall_score"]?.toDouble(),
//     overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
//     scoreDisplay: json["score_display"],
//     scoreStatus: json["score_status"],
//     isIndependent: json["is_independent"],
//     hasMmc: json["has_mmc"],
//     complex: json["complex"],
//     complexNameText: json["complex_name"]?.toString(),
//     caretaker: json["caretaker"] == null
//         ? null
//         : Caretaker.fromJson(json["caretaker"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name_number": nameNumber,
//     "type": type,
//     "location": location,
//     "area": area,
//     "bedrooms": bedrooms,
//     "floors": floors,
//     "occupancy_status": occupancyStatus,
//     "status": status,
//     "status_label": statusLabel,
//     "image_url": imageUrl,
//     "care_package": carePackage?.toJson(),
//     "overall_score": overallScore,
//     "overall_score_out_of_10": overallScoreOutOf10,
//     "score_display": scoreDisplay,
//     "score_status": scoreStatus,
//     "is_independent": isIndependent,
//     "has_mmc": hasMmc,
//     "complex": complex,
//     "complex_name": complexNameText,
//     "caretaker": caretaker?.toJson(),
//   };
// }

// class CarePackage {
//   String? key;
//   String? label;

//   CarePackage({this.key, this.label});

//   factory CarePackage.fromJson(Map<String, dynamic> json) =>
//       CarePackage(key: json["key"], label: json["label"]);

//   Map<String, dynamic> toJson() => {"key": key, "label": label};
// }

// class Caretaker {
//   int? id;
//   String? name;
//   String? phone;

//   Caretaker({this.id, this.name, this.phone});

//   factory Caretaker.fromJson(Map<String, dynamic> json) =>
//       Caretaker(id: json["id"], name: json["name"], phone: json["phone"]);

//   Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
// }

// class Widgets {
//   int? pendingIssues;
//   Complaints? serviceRequests;
//   Complaints? complaints;
//   MaintenancePayment? maintenancePayment;
//   int? openMaintenance;
//   int? documentsCount;
//   LatestInspection? latestInspection;
//   LatestAudit? latestAudit;
//   LatestAuditReport? latestAuditReport;
//   int? outstandingAmount;
//   int? unreadNotificationsCount;

//   Widgets({
//     this.pendingIssues,
//     this.serviceRequests,
//     this.complaints,
//     this.maintenancePayment,
//     this.openMaintenance,
//     this.documentsCount,
//     this.latestInspection,
//     this.latestAudit,
//     this.latestAuditReport,
//     this.outstandingAmount,
//     this.unreadNotificationsCount,
//   });

//   factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
//     pendingIssues: json["pending_issues"],
//     serviceRequests: json["service_requests"] == null
//         ? null
//         : Complaints.fromJson(json["service_requests"]),
//     complaints: json["complaints"] == null
//         ? null
//         : Complaints.fromJson(json["complaints"]),
//     maintenancePayment: json["maintenance_payment"] == null
//         ? null
//         : MaintenancePayment.fromJson(json["maintenance_payment"]),
//     openMaintenance: json["open_maintenance"],
//     documentsCount: json["documents_count"],
//     latestInspection: json["latest_inspection"] == null
//         ? null
//         : LatestInspection.fromJson(json["latest_inspection"]),
//     latestAudit: json["latest_audit"] == null
//         ? null
//         : LatestAudit.fromJson(json["latest_audit"]),
//     latestAuditReport: json["latest_audit_report"] == null
//         ? null
//         : LatestAuditReport.fromJson(json["latest_audit_report"]),
//     outstandingAmount: json["outstanding_amount"],
//     unreadNotificationsCount: json["unread_notifications_count"],
//   );

//   Map<String, dynamic> toJson() => {
//     "pending_issues": pendingIssues,
//     "service_requests": serviceRequests?.toJson(),
//     "complaints": complaints?.toJson(),
//     "maintenance_payment": maintenancePayment?.toJson(),
//     "open_maintenance": openMaintenance,
//     "documents_count": documentsCount,
//     "latest_inspection": latestInspection?.toJson(),
//     "latest_audit": latestAudit?.toJson(),
//     "latest_audit_report": latestAuditReport?.toJson(),
//     "outstanding_amount": outstandingAmount,
//     "unread_notifications_count": unreadNotificationsCount,
//   };
// }

// class Complaints {
//   int? active;
//   int? total;
//   int? pending;
//   int? inProgress;

//   Complaints({this.active, this.inProgress, this.total, this.pending});

//   factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
//     active: json["active"],
//     inProgress: json["in_progress"],
//     total: json["total"],
//     pending: json["pending"],
//   );

//   Map<String, dynamic> toJson() => {
//     "active": active,
//     "in_progress": inProgress,
//     "total": total,
//     "pending": pending,
//   };
// }

// class LatestInspection {
//   int? id;
//   DateTime? date;
//   DateTime? inspectionDate;
//   String? dateFormatted;
//   String? inspectionDateFormatted;
//   double? score;
//   String? status;
//   String? reportType;

//   LatestInspection({
//     this.id,
//     this.date,
//     this.inspectionDate,
//     this.dateFormatted,
//     this.inspectionDateFormatted,
//     this.score,
//     this.status,
//     this.reportType,
//   });

//   factory LatestInspection.fromJson(Map<String, dynamic> json) =>
//       LatestInspection(
//         id: json["id"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         inspectionDate: json["inspection_date"] == null
//             ? null
//             : DateTime.parse(json["inspection_date"]),
//         dateFormatted: json["date_formatted"],
//         inspectionDateFormatted: json["inspection_date_formatted"],
//         score: json["score"]?.toDouble(),
//         status: json["status"],
//         reportType: json["report_type"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "date": date == null
//         ? null
//         : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "inspection_date": inspectionDate == null
//         ? null
//         : "${inspectionDate!.year.toString().padLeft(4, '0')}-${inspectionDate!.month.toString().padLeft(2, '0')}-${inspectionDate!.day.toString().padLeft(2, '0')}",
//     "date_formatted": dateFormatted,
//     "inspection_date_formatted": inspectionDateFormatted,
//     "score": score,
//     "status": status,
//     "report_type": reportType,
//   };
// }

// class LatestAudit {
//   int? id;
//   String? title;
//   DateTime? createdAt;

//   LatestAudit({this.id, this.title, this.createdAt});

//   factory LatestAudit.fromJson(Map<String, dynamic> json) => LatestAudit(
//     id: json["id"],
//     title: json["title"],
//     createdAt: json["created_at"] == null
//         ? null
//         : DateTime.parse(json["created_at"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//     "created_at": createdAt?.toIso8601String(),
//   };
// }

// class LatestAuditReport {
//   int? id;
//   String? auditType;
//   DateTime? date;
//   String? dateFormatted;
//   num? score;
//   String? scoreLabel;
//   String? tier;
//   int? totalCheckpoints;
//   int? passed;
//   int? needsAttention;
//   String? checklistPdfUrl;

//   LatestAuditReport({
//     this.id,
//     this.auditType,
//     this.date,
//     this.dateFormatted,
//     this.score,
//     this.scoreLabel,
//     this.tier,
//     this.totalCheckpoints,
//     this.passed,
//     this.needsAttention,
//     this.checklistPdfUrl,
//   });

//   factory LatestAuditReport.fromJson(Map<String, dynamic> json) =>
//       LatestAuditReport(
//         id: json["id"] is int
//             ? json["id"]
//             : int.tryParse(json["id"]?.toString() ?? ""),
//         auditType: json["audit_type"],
//         date: json["date"] == null
//             ? null
//             : DateTime.tryParse(json["date"].toString()),
//         dateFormatted: json["date_formatted"],
//         score: json["score"] is num
//             ? json["score"]
//             : num.tryParse(json["score"]?.toString() ?? ""),
//         scoreLabel: json["score_label"],
//         tier: json["tier"],
//         totalCheckpoints: json["total_checkpoints"] is int
//             ? json["total_checkpoints"]
//             : int.tryParse(json["total_checkpoints"]?.toString() ?? ""),
//         passed: json["passed"] is int
//             ? json["passed"]
//             : int.tryParse(json["passed"]?.toString() ?? ""),
//         needsAttention: json["needs_attention"] is int
//             ? json["needs_attention"]
//             : int.tryParse(json["needs_attention"]?.toString() ?? ""),
//         checklistPdfUrl: json["checklist_pdf_url"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "audit_type": auditType,
//     "date": date?.toIso8601String().split('T').first,
//     "date_formatted": dateFormatted,
//     "score": score,
//     "score_label": scoreLabel,
//     "tier": tier,
//     "total_checkpoints": totalCheckpoints,
//     "passed": passed,
//     "needs_attention": needsAttention,
//     "checklist_pdf_url": checklistPdfUrl,
//   };
// }

// class MaintenancePayment {
//   bool? isApplicable;
//   String? status;
//   String? reason;
//   String? message;
//   int? outstanding;
//   int? upcoming;
//   int? overdue;
//   int? remaining;

//   MaintenancePayment({
//     this.isApplicable,
//     this.status,
//     this.reason,
//     this.message,
//     this.outstanding,
//     this.upcoming,
//     this.overdue,
//     this.remaining,
//   });

//   factory MaintenancePayment.fromJson(Map<String, dynamic> json) =>
//       MaintenancePayment(
//         isApplicable: json["is_applicable"],
//         status: json["status"],
//         reason: json["reason"],
//         message: json["message"],
//         outstanding: json["outstanding"],
//         upcoming: json["upcoming"],
//         overdue: json["overdue"],
//         remaining: json["remaining"],
//       );

//   Map<String, dynamic> toJson() => {
//     "is_applicable": isApplicable,
//     "status": status,
//     "reason": reason,
//     "message": message,
//     "outstanding": outstanding,
//     "upcoming": upcoming,
//     "overdue": overdue,
//     "remaining": remaining,
//   };
// }

// class Notice {
//   String? title;
//   String? description;
//   String? badge;

//   Notice({this.title, this.description, this.badge});

//   factory Notice.fromJson(Map<String, dynamic> json) => Notice(
//     title: json["title"],
//     description: json["description"],
//     badge: json["badge"],
//   );

//   Map<String, dynamic> toJson() => {
//     "title": title,
//     "description": description,
//     "badge": badge,
//   };
// }

// // To parse this JSON data, do
// //
// //     final ownerDashboardModel = ownerDashboardModelFromJson(jsonString);

// import 'dart:convert';

// OwnerDashboardModel ownerDashboardModelFromJson(String str) =>
//     OwnerDashboardModel.fromJson(json.decode(str));

// String ownerDashboardModelToJson(OwnerDashboardModel data) =>
//     json.encode(data.toJson());

// class OwnerDashboardModel {
//   bool? status;
//   Data? data;

//   OwnerDashboardModel({this.status, this.data});

//   factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
//       OwnerDashboardModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
// }

// class Data {
//   bool? isApproved;
//   String? approvalStatus;
//   bool? activeDashboard;
//   Property? property;
//   Widgets? widgets;
//   Notice? notice;
//   int? unreadNotificationsCount;

//   Data({
//     this.isApproved,
//     this.approvalStatus,
//     this.activeDashboard,
//     this.property,
//     this.widgets,
//     this.unreadNotificationsCount,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     isApproved: json["is_approved"],
//     approvalStatus: json["approval_status"],
//     activeDashboard: json["active_dashboard"],
//     property: json["property"] == null
//         ? null
//         : Property.fromJson(json["property"]),
//     widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
//     unreadNotificationsCount: json["unread_notifications_count"],
//   );

//   Map<String, dynamic> toJson() => {
//     "is_approved": isApproved,
//     "approval_status": approvalStatus,
//     "active_dashboard": activeDashboard,
//     "property": property?.toJson(),
//     "widgets": widgets?.toJson(),
//     "unread_notifications_count": unreadNotificationsCount,
//   };
// }

// class Property {
//   int? id;
//   String? nameNumber;
//   String? type;
//   String? location;
//   String? area;
//   String? bedrooms;
//   String? floors;
//   String? occupancyStatus;
//   String? status;
//   String? statusLabel;
//   String? imageUrl;
//   CarePackage? carePackage;
//   double? overallScore;
//   double? overallScoreOutOf10;
//   String? scoreDisplay;
//   String? scoreStatus;
//   bool? isIndependent;
//   bool? hasMmc;
//   dynamic complex;
//   Caretaker? caretaker;

//   String? get complexName {
//     if (complex == null) return null;
//     if (complex is Map) {
//       return (complex['name'] ?? complex['complex_name'])?.toString();
//     }
//     if (complex is String) return complex;
//     try {
//       return (complex as dynamic).name?.toString();
//     } catch (_) {
//       return null;
//     }
//   }

//   Property({
//     this.id,
//     this.nameNumber,
//     this.type,
//     this.location,
//     this.area,
//     this.bedrooms,
//     this.floors,
//     this.occupancyStatus,
//     this.status,
//     this.statusLabel,
//     this.imageUrl,
//     this.carePackage,
//     this.overallScore,
//     this.overallScoreOutOf10,
//     this.scoreDisplay,
//     this.scoreStatus,
//     this.isIndependent,
//     this.hasMmc,
//     this.complex,
//     this.caretaker,
//   });

//   factory Property.fromJson(Map<String, dynamic> json) => Property(
//     id: json["id"],
//     nameNumber: json["name_number"],
//     type: json["type"],
//     location: json["location"],
//     area: json["area"],
//     bedrooms: json["bedrooms"],
//     floors: json["floors"],
//     occupancyStatus: json["occupancy_status"],
//     status: json["status"],
//     statusLabel: json["status_label"],
//     imageUrl: json["image_url"],
//     carePackage: json["care_package"] == null
//         ? null
//         : CarePackage.fromJson(json["care_package"]),
//     overallScore: json["overall_score"]?.toDouble(),
//     overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
//     scoreDisplay: json["score_display"],
//     scoreStatus: json["score_status"],
//     isIndependent: json["is_independent"],
//     hasMmc: json["has_mmc"],
//     complex: json["complex"],
//     caretaker: json["caretaker"] == null
//         ? null
//         : Caretaker.fromJson(json["caretaker"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name_number": nameNumber,
//     "type": type,
//     "location": location,
//     "area": area,
//     "bedrooms": bedrooms,
//     "floors": floors,
//     "occupancy_status": occupancyStatus,
//     "status": status,
//     "status_label": statusLabel,
//     "image_url": imageUrl,
//     "care_package": carePackage?.toJson(),
//     "overall_score": overallScore,
//     "overall_score_out_of_10": overallScoreOutOf10,
//     "score_display": scoreDisplay,
//     "score_status": scoreStatus,
//     "is_independent": isIndependent,
//     "has_mmc": hasMmc,
//     "complex": complex,
//     "caretaker": caretaker?.toJson(),
//   };
// }

// class CarePackage {
//   String? key;
//   String? label;

//   CarePackage({this.key, this.label});

//   factory CarePackage.fromJson(Map<String, dynamic> json) =>
//       CarePackage(key: json["key"], label: json["label"]);

//   Map<String, dynamic> toJson() => {"key": key, "label": label};
// }

// class Caretaker {
//   int? id;
//   String? name;
//   String? phone;

//   Caretaker({this.id, this.name, this.phone});

//   factory Caretaker.fromJson(Map<String, dynamic> json) =>
//       Caretaker(id: json["id"], name: json["name"], phone: json["phone"]);

//   Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
// }

// class Widgets {
//   int? pendingIssues;
//   Complaints? serviceRequests;
//   Complaints? complaints;
//   MaintenancePayment? maintenancePayment;
//   int? openMaintenance;
//   int? documentsCount;
//   LatestInspection? latestInspection;
//   LatestAudit? latestAudit;
//   LatestAuditReport? latestAuditReport;
//   int? outstandingAmount;
//   int? unreadNotificationsCount;

//   Widgets({
//     this.pendingIssues,
//     this.serviceRequests,
//     this.complaints,
//     this.maintenancePayment,
//     this.openMaintenance,
//     this.documentsCount,
//     this.latestInspection,
//     this.latestAudit,
//     this.latestAuditReport,
//     this.outstandingAmount,
//     this.unreadNotificationsCount,
//   });

//   factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
//     pendingIssues: json["pending_issues"],
//     serviceRequests: json["service_requests"] == null
//         ? null
//         : Complaints.fromJson(json["service_requests"]),
//     complaints: json["complaints"] == null
//         ? null
//         : Complaints.fromJson(json["complaints"]),
//     maintenancePayment: json["maintenance_payment"] == null
//         ? null
//         : MaintenancePayment.fromJson(json["maintenance_payment"]),
//     openMaintenance: json["open_maintenance"],
//     documentsCount: json["documents_count"],
//     latestInspection: json["latest_inspection"] == null
//         ? null
//         : LatestInspection.fromJson(json["latest_inspection"]),
//     latestAudit: json["latest_audit"] == null
//         ? null
//         : LatestAudit.fromJson(json["latest_audit"]),
//     latestAuditReport: json["latest_audit_report"] == null
//         ? null
//         : LatestAuditReport.fromJson(json["latest_audit_report"]),
//     outstandingAmount: json["outstanding_amount"],
//     unreadNotificationsCount: json["unread_notifications_count"],
//   );

//   Map<String, dynamic> toJson() => {
//     "pending_issues": pendingIssues,
//     "service_requests": serviceRequests?.toJson(),
//     "complaints": complaints?.toJson(),
//     "maintenance_payment": maintenancePayment?.toJson(),
//     "open_maintenance": openMaintenance,
//     "documents_count": documentsCount,
//     "latest_inspection": latestInspection?.toJson(),
//     "latest_audit": latestAudit?.toJson(),
//     "latest_audit_report": latestAuditReport?.toJson(),
//     "outstanding_amount": outstandingAmount,
//     "unread_notifications_count": unreadNotificationsCount,
//   };
// }

// class Complaints {
//   int? active;
//   int? total;
//   int? pending;
//   int? inProgress;

//   Complaints({this.active, this.inProgress, this.total, this.pending});

//   factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
//     active: json["active"],
//     inProgress: json["in_progress"],
//     total: json["total"],
//     pending: json["pending"],
//   );

//   Map<String, dynamic> toJson() => {
//     "active": active,
//     "in_progress": inProgress,
//     "total": total,
//     "pending": pending,
//   };
// }

// class LatestInspection {
//   int? id;
//   DateTime? date;
//   DateTime? inspectionDate;
//   String? dateFormatted;
//   String? inspectionDateFormatted;
//   double? score;
//   String? status;
//   String? reportType;

//   LatestInspection({
//     this.id,
//     this.date,
//     this.inspectionDate,
//     this.dateFormatted,
//     this.inspectionDateFormatted,
//     this.score,
//     this.status,
//     this.reportType,
//   });

//   factory LatestInspection.fromJson(Map<String, dynamic> json) =>
//       LatestInspection(
//         id: json["id"],
//         date: json["date"] == null ? null : DateTime.parse(json["date"]),
//         inspectionDate: json["inspection_date"] == null
//             ? null
//             : DateTime.parse(json["inspection_date"]),
//         dateFormatted: json["date_formatted"],
//         inspectionDateFormatted: json["inspection_date_formatted"],
//         score: json["score"]?.toDouble(),
//         status: json["status"],
//         reportType: json["report_type"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "date": date == null
//         ? null
//         : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "inspection_date": inspectionDate == null
//         ? null
//         : "${inspectionDate!.year.toString().padLeft(4, '0')}-${inspectionDate!.month.toString().padLeft(2, '0')}-${inspectionDate!.day.toString().padLeft(2, '0')}",
//     "date_formatted": dateFormatted,
//     "inspection_date_formatted": inspectionDateFormatted,
//     "score": score,
//     "status": status,
//     "report_type": reportType,
//   };
// }

// class LatestAudit {
//   int? id;
//   String? title;
//   DateTime? createdAt;

//   LatestAudit({this.id, this.title, this.createdAt});

//   factory LatestAudit.fromJson(Map<String, dynamic> json) => LatestAudit(
//     id: json["id"],
//     title: json["title"],
//     createdAt: json["created_at"] == null
//         ? null
//         : DateTime.parse(json["created_at"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//     "created_at": createdAt?.toIso8601String(),
//   };
// }

// class LatestAuditReport {
//   int? id;
//   String? auditType;
//   DateTime? date;
//   String? dateFormatted;
//   num? score;
//   String? scoreLabel;
//   String? tier;
//   int? totalCheckpoints;
//   int? passed;
//   int? needsAttention;
//   String? checklistPdfUrl;

//   LatestAuditReport({
//     this.id,
//     this.auditType,
//     this.date,
//     this.dateFormatted,
//     this.score,
//     this.scoreLabel,
//     this.tier,
//     this.totalCheckpoints,
//     this.passed,
//     this.needsAttention,
//     this.checklistPdfUrl,
//   });

//   factory LatestAuditReport.fromJson(Map<String, dynamic> json) =>
//       LatestAuditReport(
//         id: json["id"] is int
//             ? json["id"]
//             : int.tryParse(json["id"]?.toString() ?? ""),
//         auditType: json["audit_type"],
//         date: json["date"] == null
//             ? null
//             : DateTime.tryParse(json["date"].toString()),
//         dateFormatted: json["date_formatted"],
//         score: json["score"] is num
//             ? json["score"]
//             : num.tryParse(json["score"]?.toString() ?? ""),
//         scoreLabel: json["score_label"],
//         tier: json["tier"],
//         totalCheckpoints: json["total_checkpoints"] is int
//             ? json["total_checkpoints"]
//             : int.tryParse(json["total_checkpoints"]?.toString() ?? ""),
//         passed: json["passed"] is int
//             ? json["passed"]
//             : int.tryParse(json["passed"]?.toString() ?? ""),
//         needsAttention: json["needs_attention"] is int
//             ? json["needs_attention"]
//             : int.tryParse(json["needs_attention"]?.toString() ?? ""),
//         checklistPdfUrl: json["checklist_pdf_url"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "audit_type": auditType,
//     "date": date?.toIso8601String().split('T').first,
//     "date_formatted": dateFormatted,
//     "score": score,
//     "score_label": scoreLabel,
//     "tier": tier,
//     "total_checkpoints": totalCheckpoints,
//     "passed": passed,
//     "needs_attention": needsAttention,
//     "checklist_pdf_url": checklistPdfUrl,
//   };
// }

// class MaintenancePayment {
//   bool? isApplicable;
//   String? status;
//   String? reason;
//   String? message;
//   int? outstanding;
//   int? upcoming;
//   int? overdue;
//   int? remaining;

//   MaintenancePayment({
//     this.isApplicable,
//     this.status,
//     this.reason,
//     this.message,
//     this.outstanding,
//     this.upcoming,
//     this.overdue,
//     this.remaining,
//   });

//   factory MaintenancePayment.fromJson(Map<String, dynamic> json) =>
//       MaintenancePayment(
//         isApplicable: json["is_applicable"],
//         status: json["status"],
//         reason: json["reason"],
//         message: json["message"],
//         outstanding: json["outstanding"],
//         upcoming: json["upcoming"],
//         overdue: json["overdue"],
//         remaining: json["remaining"],
//       );

//   Map<String, dynamic> toJson() => {
//     "is_applicable": isApplicable,
//     "status": status,
//     "reason": reason,
//     "message": message,
//     "outstanding": outstanding,
//     "upcoming": upcoming,
//     "overdue": overdue,
//     "remaining": remaining,
//   };
// }

// class Notice {
//   String? title;
//   String? description;
//   String? badge;

//   Notice({this.title, this.description, this.badge});

//   factory Notice.fromJson(Map<String, dynamic> json) => Notice(
//     title: json["title"],
//     description: json["description"],
//     badge: json["badge"],
//   );

//   Map<String, dynamic> toJson() => {
//     "title": title,
//     "description": description,
//     "badge": badge,
//   };
// }

// To parse this JSON data, do
//
//     final ownerDashboardModel = ownerDashboardModelFromJson(jsonString);

import 'dart:convert';

/// Paisa / amount kabhi int (1500) kabhi decimal (2948.82, GST ke baad) ya string aata hai -
/// int? me seedha dalne par app crash ("double is not a subtype of int") hota tha.
num? _asNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString().replaceAll(',', '').trim());
}

OwnerDashboardModel ownerDashboardModelFromJson(String str) =>
    OwnerDashboardModel.fromJson(json.decode(str));

String ownerDashboardModelToJson(OwnerDashboardModel data) =>
    json.encode(data.toJson());

class OwnerDashboardModel {
  bool? status;
  Data? data;

  OwnerDashboardModel({this.status, this.data});

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      OwnerDashboardModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  bool? isApproved;
  String? approvalStatus;
  bool? activeDashboard;
  Property? property;
  Widgets? widgets;
  Notice? notice;
  int? unreadNotificationsCount;

  Data({
    this.isApproved,
    this.approvalStatus,
    this.activeDashboard,
    this.property,
    this.widgets,
    this.unreadNotificationsCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isApproved: json["is_approved"],
    approvalStatus: json["approval_status"],
    activeDashboard: json["active_dashboard"],
    property: json["property"] == null
        ? null
        : Property.fromJson(json["property"]),
    widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
    unreadNotificationsCount: json["unread_notifications_count"],
  );

  Map<String, dynamic> toJson() => {
    "is_approved": isApproved,
    "approval_status": approvalStatus,
    "active_dashboard": activeDashboard,
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
  String? bedrooms;
  String? floors;
  String? occupancyStatus;
  String? status;
  String? statusLabel;
  String? imageUrl;
  CarePackage? carePackage;
  double? overallScore;
  double? overallScoreOutOf10;
  String? scoreDisplay;
  String? scoreStatus;
  bool? isIndependent;
  bool? hasMmc;
  dynamic complex;
  // Owner side Apartment / Villa: complex sirf naam (backend "complex_name")
  String? complexNameText;
  Caretaker? caretaker;

  String? get complexName {
    if (complex == null) {
      final t = complexNameText;
      return (t != null && t.trim().isNotEmpty) ? t : null;
    }
    if (complex is Map) {
      return (complex['name'] ?? complex['complex_name'])?.toString();
    }
    if (complex is String) return complex;
    try {
      return (complex as dynamic).name?.toString();
    } catch (_) {
      return null;
    }
  }

  Property({
    this.id,
    this.nameNumber,
    this.type,
    this.location,
    this.area,
    this.bedrooms,
    this.floors,
    this.occupancyStatus,
    this.status,
    this.statusLabel,
    this.imageUrl,
    this.carePackage,
    this.overallScore,
    this.overallScoreOutOf10,
    this.scoreDisplay,
    this.scoreStatus,
    this.isIndependent,
    this.hasMmc,
    this.complex,
    this.complexNameText,
    this.caretaker,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    nameNumber: json["name_number"],
    type: json["type"],
    location: json["location"],
    area: json["area"],
    bedrooms: json["bedrooms"],
    floors: json["floors"],
    occupancyStatus: json["occupancy_status"],
    status: json["status"],
    statusLabel: json["status_label"],
    imageUrl: json["image_url"],
    carePackage: json["care_package"] == null
        ? null
        : CarePackage.fromJson(json["care_package"]),
    overallScore: json["overall_score"]?.toDouble(),
    overallScoreOutOf10: json["overall_score_out_of_10"]?.toDouble(),
    scoreDisplay: json["score_display"],
    scoreStatus: json["score_status"],
    isIndependent: json["is_independent"],
    hasMmc: json["has_mmc"],
    complex: json["complex"],
    complexNameText: json["complex_name"]?.toString(),
    caretaker: json["caretaker"] == null
        ? null
        : Caretaker.fromJson(json["caretaker"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_number": nameNumber,
    "type": type,
    "location": location,
    "area": area,
    "bedrooms": bedrooms,
    "floors": floors,
    "occupancy_status": occupancyStatus,
    "status": status,
    "status_label": statusLabel,
    "image_url": imageUrl,
    "care_package": carePackage?.toJson(),
    "overall_score": overallScore,
    "overall_score_out_of_10": overallScoreOutOf10,
    "score_display": scoreDisplay,
    "score_status": scoreStatus,
    "is_independent": isIndependent,
    "has_mmc": hasMmc,
    "complex": complex,
    "complex_name": complexNameText,
    "caretaker": caretaker?.toJson(),
  };
}

class CarePackage {
  String? key;
  String? label;

  CarePackage({this.key, this.label});

  factory CarePackage.fromJson(Map<String, dynamic> json) =>
      CarePackage(key: json["key"], label: json["label"]);

  Map<String, dynamic> toJson() => {"key": key, "label": label};
}

class Caretaker {
  int? id;
  String? name;
  String? phone;

  Caretaker({this.id, this.name, this.phone});

  factory Caretaker.fromJson(Map<String, dynamic> json) =>
      Caretaker(id: json["id"], name: json["name"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
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
  LatestAuditReport? latestAuditReport;
  num? outstandingAmount;
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
    this.latestAuditReport,
    this.outstandingAmount,
    this.unreadNotificationsCount,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
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
    latestInspection: json["latest_inspection"] == null
        ? null
        : LatestInspection.fromJson(json["latest_inspection"]),
    latestAudit: json["latest_audit"] == null
        ? null
        : LatestAudit.fromJson(json["latest_audit"]),
    latestAuditReport: json["latest_audit_report"] == null
        ? null
        : LatestAuditReport.fromJson(json["latest_audit_report"]),
    outstandingAmount: _asNum(json["outstanding_amount"]),
    unreadNotificationsCount: json["unread_notifications_count"],
  );

  Map<String, dynamic> toJson() => {
    "pending_issues": pendingIssues,
    "service_requests": serviceRequests?.toJson(),
    "complaints": complaints?.toJson(),
    "maintenance_payment": maintenancePayment?.toJson(),
    "open_maintenance": openMaintenance,
    "documents_count": documentsCount,
    "latest_inspection": latestInspection?.toJson(),
    "latest_audit": latestAudit?.toJson(),
    "latest_audit_report": latestAuditReport?.toJson(),
    "outstanding_amount": outstandingAmount,
    "unread_notifications_count": unreadNotificationsCount,
  };
}

class Complaints {
  int? active;
  int? total;
  int? pending;
  int? inProgress;

  Complaints({this.active, this.inProgress, this.total, this.pending});

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
    active: json["active"],
    inProgress: json["in_progress"],
    total: json["total"],
    pending: json["pending"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "in_progress": inProgress,
    "total": total,
    "pending": pending,
  };
}

class LatestInspection {
  int? id;
  DateTime? date;
  DateTime? inspectionDate;
  String? dateFormatted;
  String? inspectionDateFormatted;
  double? score;
  String? status;
  String? reportType;

  LatestInspection({
    this.id,
    this.date,
    this.inspectionDate,
    this.dateFormatted,
    this.inspectionDateFormatted,
    this.score,
    this.status,
    this.reportType,
  });

  factory LatestInspection.fromJson(Map<String, dynamic> json) =>
      LatestInspection(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        inspectionDate: json["inspection_date"] == null
            ? null
            : DateTime.parse(json["inspection_date"]),
        dateFormatted: json["date_formatted"],
        inspectionDateFormatted: json["inspection_date_formatted"],
        score: json["score"]?.toDouble(),
        status: json["status"],
        reportType: json["report_type"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "inspection_date": inspectionDate == null
        ? null
        : "${inspectionDate!.year.toString().padLeft(4, '0')}-${inspectionDate!.month.toString().padLeft(2, '0')}-${inspectionDate!.day.toString().padLeft(2, '0')}",
    "date_formatted": dateFormatted,
    "inspection_date_formatted": inspectionDateFormatted,
    "score": score,
    "status": status,
    "report_type": reportType,
  };
}

class LatestAudit {
  int? id;
  String? title;
  DateTime? createdAt;

  LatestAudit({this.id, this.title, this.createdAt});

  factory LatestAudit.fromJson(Map<String, dynamic> json) => LatestAudit(
    id: json["id"],
    title: json["title"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created_at": createdAt?.toIso8601String(),
  };
}

class LatestAuditReport {
  int? id;
  String? auditType;
  DateTime? date;
  String? dateFormatted;
  num? score;
  String? scoreLabel;
  String? tier;
  int? totalCheckpoints;
  int? passed;
  int? needsAttention;
  String? checklistPdfUrl;

  LatestAuditReport({
    this.id,
    this.auditType,
    this.date,
    this.dateFormatted,
    this.score,
    this.scoreLabel,
    this.tier,
    this.totalCheckpoints,
    this.passed,
    this.needsAttention,
    this.checklistPdfUrl,
  });

  factory LatestAuditReport.fromJson(Map<String, dynamic> json) =>
      LatestAuditReport(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? ""),
        auditType: json["audit_type"],
        date: json["date"] == null
            ? null
            : DateTime.tryParse(json["date"].toString()),
        dateFormatted: json["date_formatted"],
        score: json["score"] is num
            ? json["score"]
            : num.tryParse(json["score"]?.toString() ?? ""),
        scoreLabel: json["score_label"],
        tier: json["tier"],
        totalCheckpoints: json["total_checkpoints"] is int
            ? json["total_checkpoints"]
            : int.tryParse(json["total_checkpoints"]?.toString() ?? ""),
        passed: json["passed"] is int
            ? json["passed"]
            : int.tryParse(json["passed"]?.toString() ?? ""),
        needsAttention: json["needs_attention"] is int
            ? json["needs_attention"]
            : int.tryParse(json["needs_attention"]?.toString() ?? ""),
        checklistPdfUrl: json["checklist_pdf_url"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "audit_type": auditType,
    "date": date?.toIso8601String().split('T').first,
    "date_formatted": dateFormatted,
    "score": score,
    "score_label": scoreLabel,
    "tier": tier,
    "total_checkpoints": totalCheckpoints,
    "passed": passed,
    "needs_attention": needsAttention,
    "checklist_pdf_url": checklistPdfUrl,
  };
}

class MaintenancePayment {
  bool? isApplicable;
  String? status;
  String? reason;
  String? message;
  num? outstanding;
  num? upcoming;
  num? overdue;
  num? remaining;

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

  factory MaintenancePayment.fromJson(Map<String, dynamic> json) =>
      MaintenancePayment(
        isApplicable: json["is_applicable"],
        status: json["status"],
        reason: json["reason"],
        message: json["message"],
        outstanding: _asNum(json["outstanding"]),
        upcoming: _asNum(json["upcoming"]),
        overdue: _asNum(json["overdue"]),
        remaining: _asNum(json["remaining"]),
      );

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

class Notice {
  String? title;
  String? description;
  String? badge;

  Notice({this.title, this.description, this.badge});

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    title: json["title"],
    description: json["description"],
    badge: json["badge"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "badge": badge,
  };
}
