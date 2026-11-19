// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:property_care/core/AuthService/AuthServiceProvider.dart';

// final getUnassignedPropertyProvider = FutureProvider.autoDispose((ref) async {
//   final service = ref.read(authServiceProvider);
//   return await service.getUnassignedProperty();
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/GetUnAssignedResModel.dart'
    show GetUnAssignedResModel, Datum;

const String _complexesApi = "https://admin.ascentpms.care/api/v1/complexes";

/// Add Property: SAARE Community complexes ke naam (Bharat Apartment jaise Association wale bhi).
/// Owner ki property mein complex sirf NAAM ki tarah save hota hai - Community side kuch nahi judta.
/// (Pehle "/complexes/unassigned-head" se sirf bina Association wale complex aate the.)
final getUnassignedPropertyProvider =
    FutureProvider.autoDispose<GetUnAssignedResModel>((ref) async {
      final dio = ref.read(dioProvider);
      final res = await dio.get(_complexesApi);
      final body = res.data;
      final List list = (body is Map && body["data"] is List)
          ? body["data"] as List
          : const [];
      return GetUnAssignedResModel(
        status: body is Map ? body["status"] == true : false,
        message: body is Map ? body["message"]?.toString() : null,
        data: list
            .whereType<Map>()
            .map(
              (m) => Datum(
                id: m["id"] is int
                    ? m["id"] as int
                    : int.tryParse("${m["id"]}"),
                name: m["name"]?.toString(),
                address: m["address"]?.toString(),
              ),
            )
            .where((d) => d.id != null && (d.name ?? "").trim().isNotEmpty)
            .toList(),
      );
    });
