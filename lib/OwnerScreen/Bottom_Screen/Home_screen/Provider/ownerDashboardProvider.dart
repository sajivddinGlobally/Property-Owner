import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/ownerDashboardModel.dart';

final ownerDashboardProvider = FutureProvider.autoDispose<OwnerDashboardModel>((
  ref,
) async {
  final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
  final service = ref.read(authServiceProvider);

  try {
    final dashboard = await service.getOwnerDashboardData(
      propertyId: selectedPropertyId,
    );

    // If selectedPropertyId was null, but dashboard returned a property, sync it immediately:
    if (selectedPropertyId == null && dashboard.data?.property?.id != null) {
      final returnedId = dashboard.data!.property!.id;
      log("ownerDashboardProvider syncing selectedPropertyId to $returnedId");
      Future.microtask(() {
        ref.read(selectedPropertyIdProvider.notifier).state = returnedId;
        persistSelectedPropertyId(returnedId);
      });
    }

    return dashboard;
  } catch (e) {
    // If request failed with selectedPropertyId (e.g. from previous user or invalid id),
    // fallback to default property (propertyId: null):
    if (selectedPropertyId != null) {
      log(
        "ownerDashboardProvider failed with propertyId $selectedPropertyId, retrying with null: $e",
      );
      final dashboard = await service.getOwnerDashboardData(propertyId: null);
      if (dashboard.data?.property?.id != null) {
        final returnedId = dashboard.data!.property!.id;
        Future.microtask(() {
          ref.read(selectedPropertyIdProvider.notifier).state = returnedId;
          persistSelectedPropertyId(returnedId);
        });
      }
      return dashboard;
    }
    rethrow;
  }
});
