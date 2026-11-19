/// GET /api/v1/owner/rent-bills  ->  Rent & Bills (ek property)
/// List kabhi array kabhi map aa sakti hai - dono sambhale. Paise int / double / string teeno.

num _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v;
  return num.tryParse(v.toString().replaceAll(',', '').trim()) ?? 0;
}

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

List<Map<String, dynamic>> _list(dynamic raw) {
  final items = raw is List
      ? raw
      : (raw is Map ? raw.values.toList() : const <dynamic>[]);
  return items
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

class RentBillsData {
  final RbProperty property;
  final RbTenant? tenant;
  final RbTotals totals;
  final List<RbRentRow> rentHistory;
  final List<RbBill> bills;

  RentBillsData({
    required this.property,
    required this.tenant,
    required this.totals,
    required this.rentHistory,
    required this.bills,
  });

  factory RentBillsData.fromJson(Map<String, dynamic> json) {
    final t = json["tenant"];
    return RentBillsData(
      property: RbProperty.fromJson(
        json["property"] is Map
            ? Map<String, dynamic>.from(json["property"])
            : {},
      ),
      tenant: t is Map ? RbTenant.fromJson(Map<String, dynamic>.from(t)) : null,
      totals: RbTotals.fromJson(
        json["totals"] is Map ? Map<String, dynamic>.from(json["totals"]) : {},
      ),
      rentHistory: _list(json["rent_history"]).map(RbRentRow.fromJson).toList(),
      bills: _list(json["bills"]).map(RbBill.fromJson).toList(),
    );
  }
}

class RbProperty {
  final dynamic id;
  final String name;
  final String? typeLabel;
  final String? occupancy;
  final String? occupancyLabel;

  RbProperty({
    this.id,
    required this.name,
    this.typeLabel,
    this.occupancy,
    this.occupancyLabel,
  });

  factory RbProperty.fromJson(Map<String, dynamic> j) => RbProperty(
    id: j["id"],
    name: _str(j["name"]) ?? "-",
    typeLabel: _str(j["type_label"]),
    occupancy: _str(j["occupancy"]),
    occupancyLabel: _str(j["occupancy_label"]),
  );
}

class RbTenant {
  final String name;
  final String? phone;
  final String? imageUrl;
  final String tenantType;
  final num monthlyRent;
  final String? leaseStart;
  final String? leaseEnd;
  final String rentStatus; // paid | unpaid | overdue
  final String rentStatusLabel;
  final bool isDefaulter;
  final String? nextDueDate;

  RbTenant({
    required this.name,
    this.phone,
    this.imageUrl,
    required this.tenantType,
    required this.monthlyRent,
    this.leaseStart,
    this.leaseEnd,
    required this.rentStatus,
    required this.rentStatusLabel,
    required this.isDefaulter,
    this.nextDueDate,
  });

  factory RbTenant.fromJson(Map<String, dynamic> j) => RbTenant(
    name: _str(j["name"]) ?? "-",
    phone: _str(j["phone"]),
    imageUrl: _str(j["image_url"]),
    tenantType: _str(j["tenant_type"]) ?? "Primary Tenant",
    monthlyRent: _num(j["monthly_rent"]),
    leaseStart: _str(j["lease_start"]),
    leaseEnd: _str(j["lease_end"]),
    rentStatus: _str(j["rent_status"]) ?? "unpaid",
    rentStatusLabel: _str(j["rent_status_label"]) ?? "Unpaid",
    isDefaulter: j["is_defaulter"] == true,
    nextDueDate: _str(j["next_due_date"]),
  );
}

class RbTotals {
  final num rentDue;
  final int rentDueMonths;
  final num billsDueTenant;
  final num billsDueOwner;

  RbTotals({
    required this.rentDue,
    required this.rentDueMonths,
    required this.billsDueTenant,
    required this.billsDueOwner,
  });

  factory RbTotals.fromJson(Map<String, dynamic> j) => RbTotals(
    rentDue: _num(j["rent_due"]),
    rentDueMonths: _num(j["rent_due_months"]).toInt(),
    billsDueTenant: _num(j["bills_due_tenant"]),
    billsDueOwner: _num(j["bills_due_owner"]),
  );
}

class RbRentRow {
  final dynamic id;
  final String month;
  final String? tenantName;
  final num amount;
  final String? dueDate;
  final String? paidOn;
  final String status; // paid | unpaid | overdue
  final String statusLabel;
  final bool isDefaulter;
  final int daysLate;

  RbRentRow({
    this.id,
    required this.month,
    this.tenantName,
    required this.amount,
    this.dueDate,
    this.paidOn,
    required this.status,
    required this.statusLabel,
    required this.isDefaulter,
    required this.daysLate,
  });

  factory RbRentRow.fromJson(Map<String, dynamic> j) => RbRentRow(
    id: j["id"],
    month: _str(j["month"]) ?? "-",
    tenantName: _str(j["tenant_name"]),
    amount: _num(j["amount"]),
    dueDate: _str(j["due_date"]),
    paidOn: _str(j["paid_on"]),
    status: _str(j["status"]) ?? "unpaid",
    statusLabel: _str(j["status_label"]) ?? "Unpaid",
    isDefaulter: j["is_defaulter"] == true,
    daysLate: _num(j["days_late"]).toInt(),
  );
}

class RbBill {
  final dynamic id;
  final String type;
  final String typeLabel;
  final String? title;
  final String month;
  final num amount;
  final String? dueDate;
  final String? paidOn;
  final String paidBy; // tenant | owner
  final String? tenantName;
  final String status; // paid | unpaid | overdue
  final String statusLabel;
  final int daysLate;
  final String? note;

  RbBill({
    this.id,
    required this.type,
    required this.typeLabel,
    this.title,
    required this.month,
    required this.amount,
    this.dueDate,
    this.paidOn,
    required this.paidBy,
    this.tenantName,
    required this.status,
    required this.statusLabel,
    required this.daysLate,
    this.note,
  });

  bool get isOwner => paidBy == "owner";

  /// "Electricity - November 2026" jaisa apne aap bana title na dikhao
  String? get extraTitle {
    final t = title;
    if (t == null || t.startsWith("$typeLabel - ")) return null;
    return t;
  }

  factory RbBill.fromJson(Map<String, dynamic> j) => RbBill(
    id: j["id"],
    type: _str(j["type"]) ?? "other",
    typeLabel: _str(j["type_label"]) ?? "Bill",
    title: _str(j["title"]),
    month: _str(j["month"]) ?? "-",
    amount: _num(j["amount"]),
    dueDate: _str(j["due_date"]),
    paidOn: _str(j["paid_on"]),
    paidBy: _str(j["paid_by"]) == "owner" ? "owner" : "tenant",
    tenantName: _str(j["tenant_name"]),
    status: _str(j["status"]) ?? "unpaid",
    statusLabel: _str(j["status_label"]) ?? "Unpaid",
    daysLate: _num(j["days_late"]).toInt(),
    note: _str(j["note"]),
  );
}
