import 'package:dio/dio.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart'
    show selectedPropertyIdProvider;
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/Data/Model/ResponseModel/rentBillsModel.dart';

const String _rentBillsApi =
    "https://admin.ascentpms.care/api/v1/owner/rent-bills";

/// Rent & Bills (chuni hui property). Galti ho to backend ka message Exception me.
final rentBillsProvider = FutureProvider.autoDispose<RentBillsData>((
  ref,
) async {
  final propertyId = ref.watch(selectedPropertyIdProvider);
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get(
      _rentBillsApi,
      queryParameters: {if (propertyId != null) "property_id": propertyId},
    );
    final body = response.data;
    if (body is Map && body["status"] == true && body["data"] is Map) {
      return RentBillsData.fromJson(Map<String, dynamic>.from(body["data"]));
    }
    throw Exception(
      body is Map && body["message"] != null
          ? body["message"].toString()
          : "Could not load rent and bills.",
    );
  } on DioException catch (e) {
    final data = e.response?.data;
    if (data is Map && data["message"] != null) {
      throw Exception(data["message"].toString());
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw Exception("No internet connection. Please try again.");
    }
    throw Exception("Could not load rent and bills.");
  }
});
