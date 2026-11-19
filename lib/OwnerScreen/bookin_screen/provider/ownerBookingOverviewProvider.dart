import 'package:dio/dio.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart'
    show selectedPropertyIdProvider;
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/Data/Model/ResponseModel/OwnerBookingOverview.dart';

const String _bookingOverviewApi =
    "https://admin.ascentpms.care/api/v1/owner/bookings/overview";

/// month = "YYYY-MM" (null = is mahina). Earn n Care ke bahar backend 403 deta hai.
final ownerBookingOverviewProvider = FutureProvider.autoDispose
    .family<OwnerBookingOverview, String?>((ref, month) async {
      final propertyId = ref.watch(selectedPropertyIdProvider);
      final dio = ref.read(dioProvider);
      try {
        final response = await dio.get(
          _bookingOverviewApi,
          queryParameters: {
            if (propertyId != null) "property_id": propertyId,
            if (month != null && month.isNotEmpty) "month": month,
          },
        );
        final body = response.data;
        if (body is Map && body["status"] == true) {
          return OwnerBookingOverview.fromJson(Map<String, dynamic>.from(body));
        }
        throw Exception(
          body is Map && body["message"] != null
              ? body["message"].toString()
              : "Could not load bookings.",
        );
      } on DioException catch (e) {
        final data = e.response?.data;
        throw Exception(
          data is Map && data["message"] != null
              ? data["message"].toString()
              : "Could not load bookings.",
        );
      }
    });

const String _bookingReportApi =
    "https://admin.ascentpms.care/api/v1/owner/bookings/report";

/// Custom range report. from / to = "YYYY-MM-DD". Galti ho to backend ka message Exception me.
/// (Screen se: fetchOwnerBookingReport(ref.read(dioProvider), ref.read(selectedPropertyIdProvider), from, to))
Future<BookingRangeReport> fetchOwnerBookingReport(
  Dio dio,
  dynamic propertyId,
  String from,
  String to,
) async {
  try {
    final response = await dio.get(
      _bookingReportApi,
      queryParameters: {
        if (propertyId != null) "property_id": propertyId,
        "from": from,
        "to": to,
      },
    );
    final body = response.data;
    if (body is Map && body["status"] == true) {
      return BookingRangeReport.fromJson(Map<String, dynamic>.from(body));
    }
    throw Exception(
      body is Map && body["message"] != null
          ? body["message"].toString()
          : "Could not load the report.",
    );
  } on DioException catch (e) {
    final data = e.response?.data;
    throw Exception(
      data is Map && data["message"] != null
          ? data["message"].toString()
          : "Could not load the report.",
    );
  }
}
