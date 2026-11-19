// Earn n Care - Booking & Rental (owner sirf dekhta hai).
// Hand-written model (retrofit / build_runner ki zaroorat nahi). Guest ki personal details API se aati hi nahi.

double _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _int(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

String _str(dynamic v, [String d = ""]) => v == null ? d : v.toString();

class OwnerBookingOverview {
  final String propertyName;
  final BookingSummary summary;
  final BookingLifetime lifetime;
  final List<BookingDay> days;
  final List<OwnerBooking> bookings;
  final List<BookingListing> listings;
  final String?
  statementDownloadUrl; // mahine ka statement PDF (signed link, 60 min)

  OwnerBookingOverview({
    required this.propertyName,
    required this.summary,
    required this.lifetime,
    required this.days,
    required this.bookings,
    required this.listings,
    this.statementDownloadUrl,
  });

  factory OwnerBookingOverview.fromJson(Map<String, dynamic> json) {
    final data = (json["data"] is Map)
        ? Map<String, dynamic>.from(json["data"])
        : <String, dynamic>{};
    List<T> list<T>(String key, T Function(Map<String, dynamic>) f) {
      final raw = data[key];
      if (raw is! List) return <T>[];
      return raw
          .whereType<Map>()
          .map((e) => f(Map<String, dynamic>.from(e)))
          .toList();
    }

    final property = data["property"] is Map
        ? Map<String, dynamic>.from(data["property"])
        : <String, dynamic>{};
    return OwnerBookingOverview(
      propertyName: _str(property["name"]),
      summary: BookingSummary.fromJson(
        data["summary"] is Map
            ? Map<String, dynamic>.from(data["summary"])
            : <String, dynamic>{},
      ),
      lifetime: BookingLifetime.fromJson(
        data["lifetime"] is Map
            ? Map<String, dynamic>.from(data["lifetime"])
            : <String, dynamic>{},
      ),
      days: list("days", BookingDay.fromJson),
      bookings: list("bookings", OwnerBooking.fromJson),
      listings: list("listings", BookingListing.fromJson),
      statementDownloadUrl: data["statement_download_url"] == null
          ? null
          : _str(data["statement_download_url"]),
    );
  }
}

class BookingSummary {
  final String month; // YYYY-MM
  final String monthLabel;
  final int totalBookings;
  final int cancelled;
  final int bookedNights;
  final int daysInMonth;
  final double occupancyPercent;
  final int rentalBookings;
  final int jvBookings;
  final double grossAmount;
  final double netAmount;
  final double ownerShare;
  final double paidAmount;
  final double pendingAmount;

  BookingSummary({
    required this.month,
    required this.monthLabel,
    required this.totalBookings,
    required this.cancelled,
    required this.bookedNights,
    required this.daysInMonth,
    required this.occupancyPercent,
    required this.rentalBookings,
    required this.jvBookings,
    required this.grossAmount,
    required this.netAmount,
    required this.ownerShare,
    required this.paidAmount,
    required this.pendingAmount,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> j) => BookingSummary(
    month: _str(j["month"]),
    monthLabel: _str(j["month_label"]),
    totalBookings: _int(j["total_bookings"]),
    cancelled: _int(j["cancelled"]),
    bookedNights: _int(j["booked_nights"]),
    daysInMonth: _int(j["days_in_month"]),
    occupancyPercent: _num(j["occupancy_percent"]),
    rentalBookings: _int(j["rental_bookings"]),
    jvBookings: _int(j["jv_bookings"]),
    grossAmount: _num(j["gross_amount"]),
    netAmount: _num(j["net_amount"]),
    ownerShare: _num(j["owner_share"]),
    paidAmount: _num(j["paid_amount"]),
    pendingAmount: _num(j["pending_amount"]),
  );
}

class BookingLifetime {
  final int totalBookings;
  final double ownerShare;
  final double paidAmount;
  final double pendingAmount;

  BookingLifetime({
    required this.totalBookings,
    required this.ownerShare,
    required this.paidAmount,
    required this.pendingAmount,
  });

  factory BookingLifetime.fromJson(Map<String, dynamic> j) => BookingLifetime(
    totalBookings: _int(j["total_bookings"]),
    ownerShare: _num(j["owner_share"]),
    paidAmount: _num(j["paid_amount"]),
    pendingAmount: _num(j["pending_amount"]),
  );
}

class BookingDay {
  final String date; // YYYY-MM-DD
  final int day;
  final bool isBooked;
  final bool isToday;

  BookingDay({
    required this.date,
    required this.day,
    required this.isBooked,
    required this.isToday,
  });

  factory BookingDay.fromJson(Map<String, dynamic> j) => BookingDay(
    date: _str(j["date"]),
    day: _int(j["day"]),
    isBooked: j["is_booked"] == true,
    isToday: j["is_today"] == true,
  );
}

class OwnerBooking {
  final int id;
  final String reference;
  final String bookingType;
  final String bookingTypeLabel;
  final String sourceLabel;
  final String checkIn; // YYYY-MM-DD
  final String checkOut;
  final String checkInLabel;
  final String checkOutLabel;
  final int nights;
  final String status;
  final String statusLabel;
  final double grossAmount;
  final double platformFee;
  final double managementFee;
  final double ownerPercent;
  final double ownerShare;
  final String payoutStatus;
  final String payoutStatusLabel;
  final String? payoutDate;

  OwnerBooking({
    required this.id,
    required this.reference,
    required this.bookingType,
    required this.bookingTypeLabel,
    required this.sourceLabel,
    required this.checkIn,
    required this.checkOut,
    required this.checkInLabel,
    required this.checkOutLabel,
    required this.nights,
    required this.status,
    required this.statusLabel,
    required this.grossAmount,
    required this.platformFee,
    required this.managementFee,
    required this.ownerPercent,
    required this.ownerShare,
    required this.payoutStatus,
    required this.payoutStatusLabel,
    this.payoutDate,
  });

  /// Is raat (ya check-in / check-out ke din) ki booking?
  bool coversDate(String date) =>
      checkIn.compareTo(date) <= 0 && checkOut.compareTo(date) >= 0;

  factory OwnerBooking.fromJson(Map<String, dynamic> j) => OwnerBooking(
    id: _int(j["id"]),
    reference: _str(j["reference"]),
    bookingType: _str(j["booking_type"]),
    bookingTypeLabel: _str(j["booking_type_label"]),
    sourceLabel: _str(j["source_label"]),
    checkIn: _str(j["check_in"]),
    checkOut: _str(j["check_out"]),
    checkInLabel: _str(j["check_in_label"]),
    checkOutLabel: _str(j["check_out_label"]),
    nights: _int(j["nights"]),
    status: _str(j["status"]),
    statusLabel: _str(j["status_label"]),
    grossAmount: _num(j["gross_amount"]),
    platformFee: _num(j["platform_fee"]),
    managementFee: _num(j["management_fee"]),
    ownerPercent: _num(j["owner_percent"]),
    ownerShare: _num(j["owner_share"]),
    payoutStatus: _str(j["payout_status"]),
    payoutStatusLabel: _str(j["payout_status_label"]),
    payoutDate: j["payout_date"] == null ? null : _str(j["payout_date"]),
  );
}

class BookingListing {
  final int id;
  final String platformLabel;
  final String? title;
  final String? url;
  final String status;
  final String statusLabel;

  BookingListing({
    required this.id,
    required this.platformLabel,
    this.title,
    this.url,
    required this.status,
    required this.statusLabel,
  });

  factory BookingListing.fromJson(Map<String, dynamic> j) => BookingListing(
    id: _int(j["id"]),
    platformLabel: _str(j["platform_label"]),
    title: j["title"] == null ? null : _str(j["title"]),
    url: j["url"] == null ? null : _str(j["url"]),
    status: _str(j["status"]),
    statusLabel: _str(j["status_label"]),
  );
}

/// Custom range (From - To) report: GET /owner/bookings/report
class BookingRangeReport {
  final String from; // YYYY-MM-DD
  final String to;
  final String rangeLabel;
  final int daysInRange;
  final int totalBookings;
  final int cancelled;
  final int bookedNights;
  final double occupancyPercent;
  final int rentalBookings;
  final int jvBookings;
  final double grossAmount;
  final double ownerShare;
  final double paidAmount;
  final double pendingAmount;
  final List<OwnerBooking> bookings;
  final String? pdfUrl; // signed link, 60 min
  final String? excelUrl; // signed link, 60 min

  BookingRangeReport({
    required this.from,
    required this.to,
    required this.rangeLabel,
    required this.daysInRange,
    required this.totalBookings,
    required this.cancelled,
    required this.bookedNights,
    required this.occupancyPercent,
    required this.rentalBookings,
    required this.jvBookings,
    required this.grossAmount,
    required this.ownerShare,
    required this.paidAmount,
    required this.pendingAmount,
    required this.bookings,
    this.pdfUrl,
    this.excelUrl,
  });

  factory BookingRangeReport.fromJson(Map<String, dynamic> json) {
    final data = (json["data"] is Map)
        ? Map<String, dynamic>.from(json["data"])
        : <String, dynamic>{};
    final s = data["summary"] is Map
        ? Map<String, dynamic>.from(data["summary"])
        : <String, dynamic>{};
    final raw = data["bookings"];
    return BookingRangeReport(
      from: _str(s["from"]),
      to: _str(s["to"]),
      rangeLabel: _str(s["range_label"]),
      daysInRange: _int(s["days_in_range"]),
      totalBookings: _int(s["total_bookings"]),
      cancelled: _int(s["cancelled"]),
      bookedNights: _int(s["booked_nights"]),
      occupancyPercent: _num(s["occupancy_percent"]),
      rentalBookings: _int(s["rental_bookings"]),
      jvBookings: _int(s["jv_bookings"]),
      grossAmount: _num(s["gross_amount"]),
      ownerShare: _num(s["owner_share"]),
      paidAmount: _num(s["paid_amount"]),
      pendingAmount: _num(s["pending_amount"]),
      bookings: raw is List
          ? raw
                .whereType<Map>()
                .map((e) => OwnerBooking.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <OwnerBooking>[],
      pdfUrl: data["pdf_url"] == null ? null : _str(data["pdf_url"]),
      excelUrl: data["excel_url"] == null ? null : _str(data["excel_url"]),
    );
  }
}
