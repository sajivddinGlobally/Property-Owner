// // To parse this JSON data, do
// //
// //     final getTenantDetailsModel = getTenantDetailsModelFromJson(jsonString);

// import 'dart:convert';

// GetTenantDetailsModel getTenantDetailsModelFromJson(String str) =>
//     GetTenantDetailsModel.fromJson(json.decode(str));

// String getTenantDetailsModelToJson(GetTenantDetailsModel data) =>
//     json.encode(data.toJson());

// class GetTenantDetailsModel {
//   bool? status;
//   Data? data;

//   GetTenantDetailsModel({this.status, this.data});

//   factory GetTenantDetailsModel.fromJson(Map<String, dynamic> json) =>
//       GetTenantDetailsModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
// }

// class Data {
//   int? propertyId;
//   String? propertyNameNumber;
//   String? carePackage;
//   PropertyDetails? propertyDetails;
//   TenantDetails? tenantDetails;
//   UtilitiesPaymentStatus? utilitiesPaymentStatus;

//   Data({
//     this.propertyId,
//     this.propertyNameNumber,
//     this.carePackage,
//     this.propertyDetails,
//     this.tenantDetails,
//     this.utilitiesPaymentStatus,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     propertyId: json["property_id"],
//     propertyNameNumber: json["property_name_number"],
//     carePackage: json["care_package"],
//     propertyDetails: json["property_details"] == null
//         ? null
//         : PropertyDetails.fromJson(json["property_details"]),
//     tenantDetails: json["tenant_details"] == null
//         ? null
//         : TenantDetails.fromJson(json["tenant_details"]),
//     utilitiesPaymentStatus: json["utilities_payment_status"] == null
//         ? null
//         : UtilitiesPaymentStatus.fromJson(json["utilities_payment_status"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "property_id": propertyId,
//     "property_name_number": propertyNameNumber,
//     "care_package": carePackage,
//     "property_details": propertyDetails?.toJson(),
//     "tenant_details": tenantDetails?.toJson(),
//     "utilities_payment_status": utilitiesPaymentStatus?.toJson(),
//   };
// }

// class PropertyDetails {
//   String? propertyType;
//   String? apartmentNo;
//   String? floor;
//   String? occupancy;
//   String? imageUrl;
//   String? complexName;

//   PropertyDetails({
//     this.propertyType,
//     this.apartmentNo,
//     this.floor,
//     this.occupancy,
//     this.imageUrl,
//     this.complexName,
//   });

//   factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
//       PropertyDetails(
//         propertyType: json["property_type"],
//         apartmentNo: json["apartment_no"],
//         floor: json["floor"],
//         occupancy: json["occupancy"],
//         imageUrl: json["image_url"],
//         complexName: json["complex_name"],
//       );

//   Map<String, dynamic> toJson() => {
//     "property_type": propertyType,
//     "apartment_no": apartmentNo,
//     "floor": floor,
//     "occupancy": occupancy,
//     "image_url": imageUrl,
//     "complex_name": complexName,
//   };
// }

// class TenantDetails {
//   int? id;
//   String? name;
//   String? tenantName;
//   dynamic imageUrl;
//   String? tenantType;
//   String? phone;
//   String? email;
//   String? moveInDate;
//   String? moveOutDate;
//   int? monthlyRent;
//   int? securityDeposit;
//   String? rentPaymentStatus;
//   String? lastRentPaidDate;
//   String? occupancyStatus;
//   String? tenantStatus;

//   TenantDetails({
//     this.id,
//     this.name,
//     this.tenantName,
//     this.imageUrl,
//     this.tenantType,
//     this.phone,
//     this.email,
//     this.moveInDate,
//     this.moveOutDate,
//     this.monthlyRent,
//     this.securityDeposit,
//     this.rentPaymentStatus,
//     this.lastRentPaidDate,
//     this.occupancyStatus,
//     this.tenantStatus,
//   });

//   factory TenantDetails.fromJson(Map<String, dynamic> json) => TenantDetails(
//     id: json["id"],
//     name: json["name"],
//     tenantName: json["tenant_name"],
//     imageUrl: json["image_url"],
//     tenantType: json["tenant_type"],
//     phone: json["phone"],
//     email: json["email"],
//     moveInDate: json["move_in_date"],
//     moveOutDate: json["move_out_date"],
//     monthlyRent: json["monthly_rent"],
//     securityDeposit: json["security_deposit"],
//     rentPaymentStatus: json["rent_payment_status"],
//     lastRentPaidDate: json["last_rent_paid_date"],
//     occupancyStatus: json["occupancy_status"],
//     tenantStatus: json["tenant_status"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "tenant_name": tenantName,
//     "image_url": imageUrl,
//     "tenant_type": tenantType,
//     "phone": phone,
//     "email": email,
//     "move_in_date": moveInDate,
//     "move_out_date": moveOutDate,
//     "monthly_rent": monthlyRent,
//     "security_deposit": securityDeposit,
//     "rent_payment_status": rentPaymentStatus,
//     "last_rent_paid_date": lastRentPaidDate,
//     "occupancy_status": occupancyStatus,
//     "tenant_status": tenantStatus,
//   };
// }

// class UtilitiesPaymentStatus {
//   Electricity? electricity;
//   Electricity? water;
//   Electricity? gas;
//   int? totalOutstanding;

//   UtilitiesPaymentStatus({
//     this.electricity,
//     this.water,
//     this.gas,
//     this.totalOutstanding,
//   });

//   factory UtilitiesPaymentStatus.fromJson(Map<String, dynamic> json) =>
//       UtilitiesPaymentStatus(
//         electricity: json["electricity"] == null
//             ? null
//             : Electricity.fromJson(json["electricity"]),
//         water: json["water"] == null
//             ? null
//             : Electricity.fromJson(json["water"]),
//         gas: json["gas"] == null ? null : Electricity.fromJson(json["gas"]),
//         totalOutstanding: json["total_outstanding"],
//       );

//   Map<String, dynamic> toJson() => {
//     "electricity": electricity?.toJson(),
//     "water": water?.toJson(),
//     "gas": gas?.toJson(),
//     "total_outstanding": totalOutstanding,
//   };
// }

// class Electricity {
//   String? status;
//   int? lastPaidAmount;

//   Electricity({this.status, this.lastPaidAmount});

//   factory Electricity.fromJson(Map<String, dynamic> json) => Electricity(
//     status: json["status"],
//     lastPaidAmount: json["last_paid_amount"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "last_paid_amount": lastPaidAmount,
//   };
// }

// To parse this JSON data, do
//
//     final getTenantDetailsModel = getTenantDetailsModelFromJson(jsonString);

import 'dart:convert';

/// Paisa / amount kabhi int (1500) kabhi decimal (2948.82, GST ke baad) ya string aata hai -
/// int? me seedha dalne par app crash ("double is not a subtype of int") hota tha.
num? _asNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString().replaceAll(',', '').trim());
}

GetTenantDetailsModel getTenantDetailsModelFromJson(String str) =>
    GetTenantDetailsModel.fromJson(json.decode(str));

String getTenantDetailsModelToJson(GetTenantDetailsModel data) =>
    json.encode(data.toJson());

class GetTenantDetailsModel {
  bool? status;
  Data? data;

  GetTenantDetailsModel({this.status, this.data});

  factory GetTenantDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetTenantDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? propertyId;
  String? propertyNameNumber;
  String? carePackage;
  PropertyDetails? propertyDetails;
  TenantDetails? tenantDetails;
  UtilitiesPaymentStatus? utilitiesPaymentStatus;

  Data({
    this.propertyId,
    this.propertyNameNumber,
    this.carePackage,
    this.propertyDetails,
    this.tenantDetails,
    this.utilitiesPaymentStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    propertyId: json["property_id"],
    propertyNameNumber: json["property_name_number"],
    carePackage: json["care_package"],
    propertyDetails: json["property_details"] == null
        ? null
        : PropertyDetails.fromJson(json["property_details"]),
    tenantDetails: json["tenant_details"] == null
        ? null
        : TenantDetails.fromJson(json["tenant_details"]),
    utilitiesPaymentStatus: json["utilities_payment_status"] == null
        ? null
        : UtilitiesPaymentStatus.fromJson(json["utilities_payment_status"]),
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "property_name_number": propertyNameNumber,
    "care_package": carePackage,
    "property_details": propertyDetails?.toJson(),
    "tenant_details": tenantDetails?.toJson(),
    "utilities_payment_status": utilitiesPaymentStatus?.toJson(),
  };
}

class PropertyDetails {
  String? propertyType;
  String? apartmentNo;
  String? floor;
  String? occupancy;
  String? imageUrl;
  String? complexName;

  PropertyDetails({
    this.propertyType,
    this.apartmentNo,
    this.floor,
    this.occupancy,
    this.imageUrl,
    this.complexName,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
      PropertyDetails(
        propertyType: json["property_type"],
        apartmentNo: json["apartment_no"],
        floor: json["floor"],
        occupancy: json["occupancy"],
        imageUrl: json["image_url"],
        complexName: json["complex_name"],
      );

  Map<String, dynamic> toJson() => {
    "property_type": propertyType,
    "apartment_no": apartmentNo,
    "floor": floor,
    "occupancy": occupancy,
    "image_url": imageUrl,
    "complex_name": complexName,
  };
}

class TenantDetails {
  int? id;
  String? name;
  String? tenantName;
  dynamic imageUrl;
  String? tenantType;
  String? phone;
  String? email;
  String? moveInDate;
  String? moveOutDate;
  num? monthlyRent;
  // Backend float bhejta hai (15000.0) - int rakhne se screen crash hoti thi
  num? securityDeposit;
  String? rentPaymentStatus;
  String? lastRentPaidDate;
  String? occupancyStatus;
  String? tenantStatus;
  // Tenant abhi rehta hai? (backend is_active; purane backend par tenant_status se)
  bool? isActive;

  TenantDetails({
    this.id,
    this.name,
    this.tenantName,
    this.imageUrl,
    this.tenantType,
    this.phone,
    this.email,
    this.moveInDate,
    this.moveOutDate,
    this.monthlyRent,
    this.securityDeposit,
    this.rentPaymentStatus,
    this.lastRentPaidDate,
    this.occupancyStatus,
    this.tenantStatus,
    this.isActive,
  });

  factory TenantDetails.fromJson(Map<String, dynamic> json) => TenantDetails(
    id: json["id"],
    name: json["name"],
    tenantName: json["tenant_name"],
    imageUrl: json["image_url"],
    tenantType: json["tenant_type"],
    phone: json["phone"],
    email: json["email"],
    moveInDate: json["move_in_date"],
    moveOutDate: json["move_out_date"],
    monthlyRent: _asNum(json["monthly_rent"]),
    securityDeposit: _asNum(json["security_deposit"]),
    rentPaymentStatus: json["rent_payment_status"],
    lastRentPaidDate: json["last_rent_paid_date"],
    occupancyStatus: json["occupancy_status"],
    tenantStatus: json["tenant_status"],
    isActive: json["is_active"] is bool
        ? json["is_active"] as bool
        : (json["tenant_status"] == null
              ? null
              : json["tenant_status"].toString().trim().toLowerCase() ==
                    "active"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tenant_name": tenantName,
    "image_url": imageUrl,
    "tenant_type": tenantType,
    "phone": phone,
    "email": email,
    "move_in_date": moveInDate,
    "move_out_date": moveOutDate,
    "monthly_rent": monthlyRent,
    "security_deposit": securityDeposit,
    "rent_payment_status": rentPaymentStatus,
    "last_rent_paid_date": lastRentPaidDate,
    "occupancy_status": occupancyStatus,
    "tenant_status": tenantStatus,
    "is_active": isActive,
  };
}

class UtilitiesPaymentStatus {
  Electricity? electricity;
  Electricity? water;
  Electricity? gas;
  Electricity? internet;
  num? totalOutstanding;

  UtilitiesPaymentStatus({
    this.electricity,
    this.water,
    this.gas,
    this.internet,
    this.totalOutstanding,
  });

  factory UtilitiesPaymentStatus.fromJson(Map<String, dynamic> json) =>
      UtilitiesPaymentStatus(
        electricity: json["electricity"] == null
            ? null
            : Electricity.fromJson(json["electricity"]),
        water: json["water"] == null
            ? null
            : Electricity.fromJson(json["water"]),
        gas: json["gas"] == null ? null : Electricity.fromJson(json["gas"]),
        internet: json["internet"] is Map<String, dynamic>
            ? Electricity.fromJson(json["internet"])
            : null,
        totalOutstanding: _asNum(json["total_outstanding"]),
      );

  Map<String, dynamic> toJson() => {
    "electricity": electricity?.toJson(),
    "water": water?.toJson(),
    "gas": gas?.toJson(),
    "internet": internet?.toJson(),
    "total_outstanding": totalOutstanding,
  };
}

class Electricity {
  String? status;
  num? lastPaidAmount;
  String? month;

  Electricity({this.status, this.lastPaidAmount, this.month});

  factory Electricity.fromJson(Map<String, dynamic> json) => Electricity(
    status: json["status"]?.toString(),
    lastPaidAmount: _asNum(json["last_paid_amount"]),
    month: json["month"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "last_paid_amount": lastPaidAmount,
    "month": month,
  };
}
