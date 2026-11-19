// // To parse this JSON data, do
// //
// //     final getTenantListModel = getTenantListModelFromJson(jsonString);

// import 'dart:convert';

// GetTenantListModel getTenantListModelFromJson(String str) =>
//     GetTenantListModel.fromJson(json.decode(str));

// String getTenantListModelToJson(GetTenantListModel data) =>
//     json.encode(data.toJson());

// class GetTenantListModel {
//   bool? status;
//   Data? data;

//   GetTenantListModel({this.status, this.data});

//   factory GetTenantListModel.fromJson(Map<String, dynamic> json) =>
//       GetTenantListModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
// }

// class Data {
//   int? totalActive;
//   List<Tenant>? tenants;

//   Data({this.totalActive, this.tenants});

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     totalActive: json["total_active"],
//     tenants: json["tenants"] == null
//         ? []
//         : List<Tenant>.from(json["tenants"]!.map((x) => Tenant.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "total_active": totalActive,
//     "tenants": tenants == null
//         ? []
//         : List<dynamic>.from(tenants!.map((x) => x.toJson())),
//   };
// }

// class Tenant {
//   int? id;
//   String? propertyNameNumber;
//   String? complexName;
//   String? name;
//   String? imageUrl;
//   String? status;
//   String? phone;
//   String? moveInDate;
//   String? moveOutDate;
//   int? monthlyRent;
//   String? rentPaymentStatus;
//   String? lastPaymentDate;
//   // Naye fields (backend tenant lifecycle): abhi rehta hai ya Moved Out
//   bool? isActiveFlag;
//   String? tenantType;
//   String? rentStatusKey;
//   num? rentOutstanding;
//   String? leaseEndDate;

//   /// Tenant abhi property me rehta hai? (purane backend par status "Active" se)
//   bool get isActive {
//     if (isActiveFlag != null) return isActiveFlag!;
//     final s = (status ?? 'Active').trim().toLowerCase();
//     return s.isEmpty || s == 'active';
//   }

//   Tenant({
//     this.id,
//     this.propertyNameNumber,
//     this.complexName,
//     this.name,
//     this.imageUrl,
//     this.status,
//     this.phone,
//     this.moveInDate,
//     this.moveOutDate,
//     this.monthlyRent,
//     this.rentPaymentStatus,
//     this.lastPaymentDate,
//     this.isActiveFlag,
//     this.tenantType,
//     this.rentStatusKey,
//     this.rentOutstanding,
//     this.leaseEndDate,
//   });

//   static int? _toInt(dynamic v) {
//     if (v == null) return null;
//     if (v is num) return v.round();
//     return num.tryParse(v.toString())?.round();
//   }

//   static num? _toNum(dynamic v) {
//     if (v == null) return null;
//     if (v is num) return v;
//     return num.tryParse(v.toString());
//   }

//   factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
//     id: json["id"],
//     propertyNameNumber: json["property_name_number"],
//     complexName: json["complex_name"],
//     name: json["name"],
//     moveOutDate: json["move_out_date"],
//     imageUrl: json["image_url"],
//     status: json["status"],
//     phone: json["phone"],
//     moveInDate: json["move_in_date"],
//     // 15000 ya 15000.5 dono chalein (pehle double aane par crash ho sakta tha)
//     monthlyRent: _toInt(json["monthly_rent"]),
//     rentPaymentStatus: json["rent_payment_status"],
//     lastPaymentDate: json["last_payment_date"],
//     isActiveFlag: json["is_active"] is bool ? json["is_active"] : null,
//     tenantType: json["tenant_type"],
//     rentStatusKey: json["rent_status_key"],
//     rentOutstanding: _toNum(json["rent_outstanding"]),
//     leaseEndDate: json["lease_end_date"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "property_name_number": propertyNameNumber,
//     "complex_name": complexName,
//     "name": name,
//     "image_url": imageUrl,
//     "status": status,
//     "phone": phone,
//     "move_out_date": moveOutDate,
//     "move_in_date": moveInDate,
//     "monthly_rent": monthlyRent,
//     "rent_payment_status": rentPaymentStatus,
//     "last_payment_date": lastPaymentDate,
//     "is_active": isActiveFlag,
//     "tenant_type": tenantType,
//     "rent_status_key": rentStatusKey,
//     "rent_outstanding": rentOutstanding,
//     "lease_end_date": leaseEndDate,
//   };
// }

// To parse this JSON data, do
//
//     final getTenantListModel = getTenantListModelFromJson(jsonString);

import 'dart:convert';

GetTenantListModel getTenantListModelFromJson(String str) =>
    GetTenantListModel.fromJson(json.decode(str));

String getTenantListModelToJson(GetTenantListModel data) =>
    json.encode(data.toJson());

class GetTenantListModel {
  bool? status;
  Data? data;

  GetTenantListModel({this.status, this.data});

  factory GetTenantListModel.fromJson(Map<String, dynamic> json) =>
      GetTenantListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? totalActive;
  List<Tenant>? tenants;

  Data({this.totalActive, this.tenants});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalActive: json["total_active"],
    tenants: json["tenants"] == null
        ? []
        : List<Tenant>.from(json["tenants"]!.map((x) => Tenant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_active": totalActive,
    "tenants": tenants == null
        ? []
        : List<dynamic>.from(tenants!.map((x) => x.toJson())),
  };
}

class Tenant {
  int? id;
  String? propertyNameNumber;
  String? complexName;
  String? name;
  String? imageUrl;
  String? status;
  String? phone;
  String? moveInDate;
  String? moveOutDate;
  num? monthlyRent;
  String? rentPaymentStatus;
  String? lastPaymentDate;
  // Naye fields (backend tenant lifecycle): abhi rehta hai ya Moved Out
  bool? isActiveFlag;
  String? tenantType;
  String? rentStatusKey;
  num? rentOutstanding;
  String? leaseEndDate;

  /// Tenant abhi property me rehta hai? (purane backend par status "Active" se)
  bool get isActive {
    if (isActiveFlag != null) return isActiveFlag!;
    final s = (status ?? 'Active').trim().toLowerCase();
    return s.isEmpty || s == 'active';
  }

  Tenant({
    this.id,
    this.propertyNameNumber,
    this.complexName,
    this.name,
    this.imageUrl,
    this.status,
    this.phone,
    this.moveInDate,
    this.moveOutDate,
    this.monthlyRent,
    this.rentPaymentStatus,
    this.lastPaymentDate,
    this.isActiveFlag,
    this.tenantType,
    this.rentStatusKey,
    this.rentOutstanding,
    this.leaseEndDate,
  });

  static num? _toNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    propertyNameNumber: json["property_name_number"],
    complexName: json["complex_name"],
    name: json["name"],
    moveOutDate: json["move_out_date"],
    imageUrl: json["image_url"],
    status: json["status"],
    phone: json["phone"],
    moveInDate: json["move_in_date"],
    // 15000 ya 15000.5 dono chalein (pehle double aane par crash ho sakta tha)
    monthlyRent: _toNum(json["monthly_rent"]),
    rentPaymentStatus: json["rent_payment_status"],
    lastPaymentDate: json["last_payment_date"],
    isActiveFlag: json["is_active"] is bool ? json["is_active"] : null,
    tenantType: json["tenant_type"],
    rentStatusKey: json["rent_status_key"],
    rentOutstanding: _toNum(json["rent_outstanding"]),
    leaseEndDate: json["lease_end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name_number": propertyNameNumber,
    "complex_name": complexName,
    "name": name,
    "image_url": imageUrl,
    "status": status,
    "phone": phone,
    "move_out_date": moveOutDate,
    "move_in_date": moveInDate,
    "monthly_rent": monthlyRent,
    "rent_payment_status": rentPaymentStatus,
    "last_payment_date": lastPaymentDate,
    "is_active": isActiveFlag,
    "tenant_type": tenantType,
    "rent_status_key": rentStatusKey,
    "rent_outstanding": rentOutstanding,
    "lease_end_date": leaseEndDate,
  };
}
